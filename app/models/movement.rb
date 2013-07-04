class Movement < ActiveRecord::Base
  belongs_to :account
  belongs_to :transfer

  attr_readonly :account_id, :transfer_id, :amount

  after_create :update_account_balance

  def update_account_balance
    account.update_balance
  end
end
