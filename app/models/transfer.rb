# A time transfer between accounts.
#
# When an amount of time is to be transferred between two accounts, a
# Transfer object should be created with the following attributes:
#
# source: id or instance of the source account
# destination: id or instance of the destination account
# amount: integer amount of time to transfer
#
# Along with the transfer, two movements are created, one in each related
# account, so the total sum of the system is zero
#
class Transfer < ApplicationRecord
  attr_accessor :source, :destination, :amount, :hours, :minutes

  belongs_to :post, optional: true
  has_many :movements, dependent: :destroy
  has_many :events, dependent: :destroy

  validates :amount, numericality: { greater_than: 0 }
  validate :different_source_and_destination

  after_create :make_movements

  def make_movements
    movements.create(account: Account.find(source_id), amount: -amount.to_i, created_at: created_at)
    movements.create(account: Account.find(destination_id), amount: amount.to_i,
                     created_at: created_at)
  end

  def source_id
    source.respond_to?(:id) ? source.id : source
  end

  def destination_id
    destination.respond_to?(:id) ? destination.id : destination
  end

  def different_source_and_destination
    return unless source == destination

    errors.add(:base, :same_account)
  end
end
