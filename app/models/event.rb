class Event < ActiveRecord::Base
  ACTIONS = ['create', 'update'].freeze

  belongs_to :post
  belongs_to :member
  belongs_to :transfer

  validates :action, inclusion: { in: ACTIONS }, presence: true
  validate :resource_presence

  private

  # Validates that only one resource id is set
  #
  def resource_presence
    return if post_id.present? ^ member_id.present? ^ transfer_id.present?

    errors.add(:base, 'Specify only one resource id: `post_id`, `member_id` or `transfer_id`')
  end
end
