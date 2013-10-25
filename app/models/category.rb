class Category < ActiveRecord::Base
  translates :name
  def to_s
    name
  end
end
