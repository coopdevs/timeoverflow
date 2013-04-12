class Organization < ActiveRecord::Base
  has_many :users
  validates_uniqueness_of :name

  def to_s
    "#{id} - #{name}"
  end
end
