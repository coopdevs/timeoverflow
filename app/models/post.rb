require 'textacular/searchable'

class Post < ActiveRecord::Base
  include Taggable
  extend Searchable :title, :description

  attr_reader :member_id

  belongs_to :category
  belongs_to :user
  belongs_to :organization
  belongs_to :publisher, :class_name => "User", :foreign_key => "publisher_id"

  has_many :user_members, class_name: "Member", through: :user, source: :members

  has_many :transfers
  has_many :movements, through: :transfers

  default_scope ->{ order('posts.updated_at DESC') }

  scope :by_category, ->(cat) { where(category_id: cat) if cat }

  scope :with_member, -> {
    joins(:organization, :user_members).
    where("members.organization_id = posts.organization_id").
    select("posts.*, members.member_uid as member_id")
  }

  scope :actives, -> {
    with_member.merge(Member.active)
  }

  validates :user, presence: true

  def to_s
    title
  end

  # will read the member_id if it has been returned by the query, otherwise
  # don't complain and return nil.
  #
  # To ensure the presence of the attribute, use the `with_member` scope
  def member_id
    read_attribute(:member_id) if has_attribute?(:member_id)
  end

end
