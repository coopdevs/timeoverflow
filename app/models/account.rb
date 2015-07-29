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
  belongs_to :organization, inverse_of: :all_accounts
  has_many :movements

  before_create :add_organization

  def update_balance
    new_balance = movements.sum(:amount)
    self.balance = new_balance
    if balance_changed?
      self.flagged = !allowed?(balance)
    end
    save
  end

  # Return the maximum allowed amount of time that the acccount is able to
  # spend without overflowing
  def allowance
    if min_allowed_balance
      [0, balance - min_allowed_balance].min
    else
      Float::INFINITY
    end
  end

  # Print the account as its accountable reference
  def to_s
    accountable.to_s
  end

  protected

  def add_organization
    self.organization = case accountable
                        when Organization
                          accountable
                        when Member
                          accountable.organization
                        end
  end


  private

  def allowed?(new_balance)
    new_balance < (max_allowed_balance || Float::INFINITY) &&
      new_balance > (min_allowed_balance || -Float::INFINITY)
  end
end
