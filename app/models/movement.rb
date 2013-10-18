# A single entry for a transfer in an account.
#
# These records should not be created nor modified by themselves.
# They are created during the creation of the corresponding Transfer record.
#
class Movement < ActiveRecord::Base
  belongs_to :account
  belongs_to :transfer

  attr_readonly :account_id, :transfer_id, :amount

  after_create do
    ap "Movement :after_create START"
    account.update_balance
    ap valid? && account.balance
    ap "Movement :after_create END"
  end

  has_one :other_side, (->(self_)  { where ["NOT movements.id = #{self_.id}"] }), through: :transfer, source: :movements
end
