class Event < ApplicationRecord
  enum action: { created: 0, updated: 1 }

  belongs_to :post, optional: true
  belongs_to :member, optional: true
  belongs_to :transfer, optional: true
  has_many :push_notifications, dependent: :destroy

  validates :action, presence: true
  validate :resource_presence

  private

  # Validates that only one resource id is set
  #
  def resource_presence
    return if post_id.present? ^ member_id.present? ^ transfer_id.present?

    errors.add(:base, "Specify only one resource id: `post_id`, `member_id` or `transfer_id`")
  end
end
