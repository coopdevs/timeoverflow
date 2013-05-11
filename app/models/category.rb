class Category < ActiveRecord::Base
  acts_as_tree
  translates :name
  attr_accessible :name, :parent_id
  belongs_to :organization

  FQN_SEPARATOR = " > "

  def fqn
    # (class memoized)
    @@memo ||= {}
    @@memo[self.id] ||= [self.parent.try(:fqn), self.name].compact.join FQN_SEPARATOR
  end

  def to_s
    name
  end

end
