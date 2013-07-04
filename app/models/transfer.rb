class Transfer < ActiveRecord::Base
  belongs_to :post
  belongs_to :operator, class_name: "User"
  has_many :movements

  after_create :make_movements

  attr_accessor :source, :destination, :amount

  def make_movements
    movements.create(account: Account.find(source), amount: -amount.to_i)
    movements.create(account: Account.find(destination), amount: amount.to_i)
  end
end
