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

  attr_accessor :source, :destination, :amount, :hours, :minutes

  def make_movements
    movements.create(account: Account.find(source), amount: -amount.to_i)
    movements.create(account: Account.find(destination), amount: amount.to_i)
  end
end
