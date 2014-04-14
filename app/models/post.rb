require 'textacular/searchable'

class Post < ActiveRecord::Base
  include Taggable
  extend Searchable :title, :description

  belongs_to :category
  belongs_to :user
  belongs_to :organization
  belongs_to :publisher, :class_name => "User", :foreign_key => "publisher_id"

  has_and_belongs_to_many :joined_users,
    class_name: "User",
    join_table: "user_joined_post",
    foreign_key: "post_id",
    association_foreign_key: "user_id"

  default_scope ->{ order('posts.created_at DESC') }

  scope :by_category, ->(cat) { where(category_id: cat) if cat }

  validates :user, presence: true

  def to_s
    title
  end

  def member_id
    organization.members.where(user_id: user_id).take.member_uid
  end
end
