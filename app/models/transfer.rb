# A time transfer between accounts.
#
# When an amount of time is to be transferred between two accounts, a
# Transfer object should be created with the followinf attributes:
#
# source: id or instance of the source account
# destination: id or instance of the destination account
# amount: integer amount of time to transfer
#
# Along with the transfer, two movements are created, one in each related
# account, so the total sum of the system is zero
#
class Transfer < ActiveRecord::Base
  belongs_to :post
  belongs_to :operator, class_name: "User"
  has_many :movements

  after_create :make_movements

  attr_accessor :source, :destination, :amount

  def make_movements
    ap "Transfer#make_movements START"
    source_account = Account.find(source)
    destination_account = Account.find(destination)
    movements.create(account: source_account, amount: -amount.to_i)
    movements.create(account: destination_account, amount: amount.to_i)
    ap valid? || errors
    ap [source_account, destination_account]
    debugger
    ap "Transfer#make_movements END"
  end
end
