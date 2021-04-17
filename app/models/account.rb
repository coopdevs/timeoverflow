# A time account for an accountable object (IE, a user, an organization...)
#
# The Account balance is denormalized in the database, and is recalculated
# every time a transfer is done from or to the account.
#
# The Account may also be flagged, if needed, when the balance overflows
# some set limits
#
class Account < ApplicationRecord
  belongs_to :accountable, polymorphic: true, optional: true
  belongs_to :organization, inverse_of: :all_accounts, optional: true
  has_many :movements

  before_create :add_organization

  # Denormalizes the account's balance summing the amount in all its movements.
  # It will flag the account if its balance falls out of the min or max limits.
  def update_balance
    new_balance = movements.sum(:amount)
    self.balance = new_balance
    self.flagged = !within_allowed_limits? if balance_changed?
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

  # Checks whether the balance falls within the max and min allowed balance,
  # none of these included
  #
  # @return [Boolean]
  def within_allowed_limits?
    less_than_upper_limit? && greater_than_lower_limit?
  end

  def less_than_upper_limit?
    balance < max_allowed_balance
  end

  def greater_than_lower_limit?
    balance > min_allowed_balance
  end

  # Returns the maximum allowed balance, falling back to infinite it not set
  #
  # @return [Integer | Float]
  def max_allowed_balance
    super || Float::INFINITY
  end

  # Returns the minimum allowed balance, falling back to minus infinite it not
  # set
  #
  # @return [Integer | Float]
  def min_allowed_balance
    super || -Float::INFINITY
  end
end
