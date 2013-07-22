class Organization < ActiveRecord::Base
  has_many :users
  validates_uniqueness_of :name

  has_one :account, as: :accountable
  after_create :create_account

  has_many :user_accounts, through: :users, source: :account

  has_many :offers, through: :users
  has_many :inquiries, through: :users

  scope :matching, ->(str) {
    where(Organization.arel_table[:name].matches("%#{str}%"))
  }

  def to_s
    "#{name}"
  end

  def ensure_reg_number_seq!
    update_column(:reg_number_seq, users.with_deleted.maximum(:registration_number))
  end

  def ensure_reg_number_seq
    ensure_reg_number_seq! unless reg_number_seq
  end

  def next_reg_number_seq
    ensure_reg_number_seq
    increment!(:reg_number_seq)
    reg_number_seq
  end

end
