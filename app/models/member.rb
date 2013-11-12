class Member < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization

  has_one :account, as: :accountable

  after_create :create_account
  before_validation :assign_registration_number, :on => :create

  validates :organization_id, presence: true
  validates :member_uid,
    presence: true,
    uniqueness: { scope: :organization_id }

  def to_s
    "#{user}"
  end

  def assign_registration_number
    self.member_uid ||= organization.next_reg_number_seq
  end

end
