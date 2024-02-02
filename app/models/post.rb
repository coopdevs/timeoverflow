class Post < ApplicationRecord
  include Taggable
  include PgSearch::Model

  pg_search_scope :search_by_query,
                  against: %i[title description tags],
                  ignoring: :accents,
                  using: {
                    tsearch: {
                      prefix: true,
                      tsvector_column: "tsv"
                    }
                  }

  attr_reader :member_id

  belongs_to :category
  belongs_to :user
  belongs_to :organization, optional: true
  has_many :transfers
  has_many :movements, through: :transfers
  has_many :events, dependent: :destroy

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

  validates :title, presence: true

  def as_indexed_json(*)
    as_json(only: %i[title description tags organization_id])
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
    RDiscount.new(description || "", :autolink)
  end
end
