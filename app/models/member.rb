class Member < ApplicationRecord
  # Cast the member_uid integer to a string to allow pg ILIKE search (from Ransack *_contains)
  ransacker :member_uid_search do
    Arel.sql("member_uid::text")
  end

  belongs_to :user
  belongs_to :organization
  has_one :account, as: :accountable
  has_many :movements, through: :account
  has_many :events, dependent: :destroy

  delegate :balance, to: :account, prefix: true, allow_nil: true
  delegate :gender, :date_of_birth, to: :user, prefix: true, allow_nil: true

  scope :by_month, -> (month) {
    where(created_at: month.beginning_of_month..month.end_of_month)
  }
  scope :active, -> { where active: true }

  validates :organization_id, presence: true
  validates :member_uid,
            presence: true,
            uniqueness: { scope: :organization_id }

  after_create :create_account
  before_validation :assign_registration_number, on: :create
  after_destroy :remove_orphaned_users

  def to_s
    "#{user}"
  end

  def display_name_with_uid
    "#{user} (#{member_uid})"
  end

  # Returns the id to be displayed in the :new transfer page
  #
  # @params _destination_accountable used to keep the same API as
  #   Organization#display_id
  # @return [Integer]
  def display_id
    member_uid
  end

  def assign_registration_number
    self.member_uid ||= organization.next_reg_number_seq
  end

  def days_without_swaps
    (DateTime.now.to_date - account.updated_at.to_date).to_i
  end

  def offers
    Post.where(organization: organization, user: user, type: "Offer")
  end

  def inquiries
    Post.where(organization: organization, user: user, type: "Inquiry")
  end

  private

  def remove_orphaned_users
    user.destroy if user && user.members.empty?
  end
end
