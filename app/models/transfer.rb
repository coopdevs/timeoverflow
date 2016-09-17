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
  attr_accessor :source, :destination, :amount, :hours, :minutes

  belongs_to :post
  belongs_to :operator, class_name: "User"
  has_many :movements

  after_create :make_movements

  # TODO: Extract it along with destination, source and amount accessors. It
  # absolutely violates encapsulation and adds high coupling.
  #
  # EDIT: It might not be that easy. The simple_form_for in give_time.html.erb
  # depends on this model having the destination column. A form object could be
  # a solution.
  def make_movements
    movements.create(account: Account.find(source_id), amount: -amount.to_i)
    movements.create(account: Account.find(destination_id), amount: amount.to_i)
  end

  def movement_from
    movements.detect {|m| m.amount < 0 }
  end

  def movement_to
    movements.detect {|m| m.amount > 0 }
  end

  def source_id
    source.respond_to?(:id) ? source.id : source
  end

  def destination_id
    destination.respond_to?(:id) ? destination.id : destination
  end
end
