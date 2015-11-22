class Member < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_one :account, as: :accountable
  has_many :movements, through: :account

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

  def remove_all_posts_from_index
    Post.with_member.where("members.id = ?", self.id).find_each do |post|
      post.delete_document
    end
  end

  def add_all_posts_to_index
    Post.with_member.where("members.id = ?", self.id).find_each do |post|
      post.update_or_delete_document(self)
    end
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
