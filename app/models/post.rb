require "textacular/searchable"

class Post < ActiveRecord::Base
  include Taggable
  extend Searchable :title, :description

  attr_reader :member_id

  belongs_to :category
  belongs_to :user
  belongs_to :organization
  belongs_to :publisher, class_name: "User", foreign_key: "publisher_id"

  has_many :user_members, class_name: "Member", through: :user, source: :members

  has_many :transfers
  has_many :movements, through: :transfers

  default_scope -> { order("posts.updated_at DESC") }

  scope :by_category, ->(cat) { where(category_id: cat) if cat }
  scope :by_organization, ->(org) { where(organization_id: org) if org }

  scope :with_member, -> {
    joins(:organization, :user_members).
      where("members.organization_id = posts.organization_id").
      select("posts.*, members.member_uid as member_id")
  }

  scope :actives, -> {
    with_member.merge(Member.active)
  }

  scope :fuzzy_and_tags, ->(s) {
    from("
    (
      (
        #{Post.fuzzy_search(s).to_sql}
      ) union(
        #{Post.tagged_with_rank(s).to_sql}
      )
    ) #{Post.table_name}")
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

  def self.active_alpha_tags(organization)
    by_organization(organization).actives.alphabetical_grouped_tags_desc.sort
  end

  def self.active_tagged_with(organization, tagname)
    by_organization(organization).actives.tagged_with(tagname)
  end

  # Merges selected_tags with a new_name for provided organization
  def self.merge_tags(organization, new_name, selected_tags)
    by_organization(organization).actives.
      rename_tags(new_name, selected_tags)
  end

  # Deletes selected tags for provided organization
  def self.delete_tags(organization, selected_tags)
    by_organization(organization).actives.
      remove_tags(selected_tags)
  end
end
