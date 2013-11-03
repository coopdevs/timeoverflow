class Post < ActiveRecord::Base
  include Taggable

  belongs_to :category
  belongs_to :user

  has_and_belongs_to_many :joined_users,
    class_name: "User",
    join_table: "user_joined_post",
    foreign_key: "post_id",
    association_foreign_key: "user_id"

  # acts_as_taggable rescue nil
   # HACK: there is a known issue that acts_as_taggable breaks asset precompilation on Heroku.

  default_scope ->{ order('posts.created_at DESC') }

  scope :categorized, ->(cat) { where(category_id: cat) if cat }

  def to_s
    title
  end
end
