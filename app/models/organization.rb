class Organization < ActiveRecord::Base
  has_many :users
  validates_uniqueness_of :name

  has_one :account, as: :accountable
  after_create :create_account

  has_many :offers, through: :users
  has_many :inquiries, through: :users

  scope :matching, ->(str) {
    where(Organization.arel_table[:name].matches("%#{str}%"))
  }

  def to_s
    "#{id} - #{name}"
  end
end
