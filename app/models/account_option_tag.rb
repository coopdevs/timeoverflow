class AccountOptionTag
  def initialize(accountable, destination_accountable)
    @accountable = accountable
    @destination_accountable = destination_accountable
  end

  def to_s
    "#{display_id} #{accountable.class} #{accountable}"
  end

  private

  attr_reader :accountable, :destination_accountable

  def display_id
    accountable.display_id(destination_accountable)
  end
end

