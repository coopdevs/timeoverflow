# A time account for an accountable object (IE, a user, an organization...)
#
# The Account balance is denormalized in the database, and is recalculated
# every time a transfer is done from or to the account.
#
# The Account may also be flagged, if needed, when the balance overflows
# some set limits
#
# TODO: How to set limits in a generic way?
#
class Account < ActiveRecord::Base
  belongs_to :accountable, polymorphic: true
  has_many :movements

  def update_balance
    new_balance = movements.sum(:amount)
    self.balance = new_balance
    if balance_changed?
      self.flagged = !allowed?(self.balance)
    end
    save
  end

  # Return the maximum allowed amount of time that the acccount is able to
  # spend without overflowing
  def allowance
    min_allowed_balance ? [0, balance - min_allowed_balance].min : Float::INFINITY
  end

  # Print the account as its accountable reference
  def to_s
    "#{accountable.class} #{accountable}"
  end

  private

  def allowed?(new_balance)
    new_balance < (max_allowed_balance || Float::INFINITY) and
      new_balance > (min_allowed_balance || -Float::INFINITY)
  end

end
