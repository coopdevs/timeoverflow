# Wraps the passed sources as a collection of HTML <option>'s value and text
# pairs as expected by Rails' #options_for_select.
class TransferSourcesOptions
  # Constructor
  #
  # @param sources [Array<Account>]
  # @param destination_accountable [Member | Organization]
  def initialize(sources, destination_accountable)
    @sources = sources
    @destination_accountable = destination_accountable
  end

  # Returns the collection as an Array containing pairs of <option>'s text and
  # value sorted by accountable type and member_uid
  #
  # @return [Array<String, Integer>]
  def to_a
    sources
      .sort_by { |account| to_accountable_type_and_uid(account) }
      .map { |account| to_text_and_value(account) }
  end

  private

  attr_reader :sources, :destination_accountable

  def to_accountable_type_and_uid(account)
    [account.accountable_type, account.accountable.try(:member_uid)]
  end

  def to_text_and_value(account)
    accountable = account.accountable

    [
      "#{display_id(accountable)} #{accountable.class} #{accountable}",
      account.id
    ]
  end

  def display_id(accountable)
    accountable.display_id(destination_accountable)
  end
end
