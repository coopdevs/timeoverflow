class Category < ActiveRecord::Base
  acts_as_tree
  attr_accessible :name, :parent_id

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
