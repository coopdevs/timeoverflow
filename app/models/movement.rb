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
    account.update_balance
  end
end
