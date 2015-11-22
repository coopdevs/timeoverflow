# A single entry for a transfer in an account.
#
# These records should not be created nor modified by themselves.
# They are created during the creation of the corresponding Transfer record.
#
class Movement < ActiveRecord::Base
  attr_readonly :account_id, :transfer_id, :amount

  belongs_to :account
  belongs_to :transfer
  has_one :other_side,
          (->(self_)  { where ["NOT movements.id = #{self_.id}"] }),
          through: :transfer,
          source: :movements

  scope :by_month,
        ->(month) {
          where(created_at: month.beginning_of_month..month.end_of_month)
        }

  after_create do
    account.update_balance
  end
end
