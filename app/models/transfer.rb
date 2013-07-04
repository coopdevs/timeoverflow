class Transfer < ActiveRecord::Base
  belongs_to :post
  belongs_to :operator, class_name: "User"
  has_many :movements

  after_create :make_movements

  attr_accessor :source, :destination, :amount

  def make_movements
    movements.create(account: source, amount: -amount)
    movements.create(account: destination, amount: amount)
  end
end
