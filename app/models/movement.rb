# A single entry for a transfer in an account.
#
# These records should not be created nor modified by themselves.
# They are created during the creation of the corresponding Transfer record.
#
class Movement < ApplicationRecord
  attr_readonly :account_id, :transfer_id, :amount

  belongs_to :account, optional: true
  belongs_to :transfer, optional: true

  scope :by_month, ->(month) { where(created_at: month.beginning_of_month..month.end_of_month) }

  validates :amount, numericality: { other_than: 0 }

  after_create do
    account.update_balance
  end

  def other_side
    transfer.movements.where.not(id: id).first
  end
end
