class Post < ActiveRecord::Base
  belongs_to :category
  belongs_to :user


  has_and_belongs_to_many :joined_users,
    class_name: "User",
    join_table: "user_joined_post",
    foreign_key: "post_id",
    association_foreign_key: "user_id"

  acts_as_taggable rescue nil
   # HACK: there is a known issue that acts_as_taggable breaks asset precompilation on Heroku.


  def to_s
    title
  end

end
