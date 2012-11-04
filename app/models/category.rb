class Category < ActiveRecord::Base
  acts_as_tree
  attr_accessible :name
end
