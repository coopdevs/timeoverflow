class Category < ActiveRecord::Base
  has_many :posts

  translates :name

  def to_s
    name
  end
end
