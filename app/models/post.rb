class Post < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  attr_accessible :description, :end_on, :global, :joinable, :permanent, :permanent, :start_on, :title


  has_and_belongs_to_many :joined_users,
    class_name: "User",
    join_table: "user_joined_post",
    foreign_key: "post_id",
    association_foreign_key: "user_id"

  acts_as_taggable

end
