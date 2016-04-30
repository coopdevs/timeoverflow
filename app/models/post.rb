require 'elasticsearch/model'

class Post < ActiveRecord::Base
  include Taggable

  # Elasticsearch::Model doesn't work well with STI, so
  # include it in subclasses directly.
  def self.inherited(child)
    super

    child.instance_eval do
      include Elasticsearch::Model

      after_commit :index_document, on: :create
      after_commit :update_or_delete_document, on: :update
      after_commit :delete_document, on: :destroy

      settings(
        analysis: {
          analyzer: {
            normal: {
              tokenizer: "standard",
              # lowercase, unaccent
              filter: %w[lowercase asciifolding]
            }
          }
        }
      ) do
        mapping do
          indexes :title, analyzer: "normal"
          indexes :description, analyzer: "normal"
          indexes :tags
          indexes :organization_id, type: :integer
        end
      end
    end
  end

  attr_reader :member_id

  belongs_to :category

  belongs_to :user
  belongs_to :organization
  belongs_to :publisher, class_name: "User", foreign_key: "publisher_id"
  # belongs_to :member, class_name: "Member", foreign_key: "user_id"
  has_many :user_members, class_name: "Member", through: :user, source: :members
  has_many :transfers
  has_many :movements, through: :transfers

  delegate :name, to: :category, prefix: true, allow_nil: true

  default_scope { order("posts.updated_at DESC") }
  scope :by_category, ->(cat) {
    where(category_id: cat) if cat
  }
  scope :by_organization, ->(org) {
    where(organization_id: org) if org
  }
  scope :of_active_members, -> {
    with_member.where("members.active")
  }
  scope :with_member, -> {
    joins("JOIN members USING (user_id, organization_id)").
      select("posts.*, members.member_uid as member_uid")
  }
  scope :active, -> {
    where(active: true)
  }
  scope :from_last_week, -> {
    where(created_at: (1.week.ago.beginning_of_day...DateTime.now.end_of_day))
  }

  validates :user, presence: true
  validates :category, presence: true
  validates :title, presence: true

  def index_document
    __elasticsearch__.index_document
  end

  # pass member when doing bulk things
  def update_or_delete_document(member = nil)
    member ||= self.member
    if active && member.try(:active)
      begin
        __elasticsearch__.update_document
      rescue # document was not in the index. TODO: more specifi exception class
        __elasticsearch__.index_document
      end
    else
      __elasticsearch__.delete_document
    end
  rescue # document was not in the index. TODO: more specifi exception class
  end

  def delete_document
    __elasticsearch__.delete_document
  rescue # document was not in the index. TODO: more specifi exception class
  end

  def as_indexed_json(*)
    as_json(only: [:title, :description, :tags, :organization_id])
  end

  def to_s
    title
  end

  # will read the member_uid if it has been returned by the query, otherwise
  # don't complain and return nil.
  #
  # To ensure the presence of the attribute, use the `with_member` scope
  def member_uid
    read_attribute(:member_uid) if has_attribute?(:member_uid)
  end

  def active?
    user && user.member(organization).try(:active) && active
  end

  def member
    @member ||= Member.find_by(user_id: user_id, organization_id: organization_id)
  end

  def rendered_description
    RDiscount.new(description || '', :autolink)
  end
end
