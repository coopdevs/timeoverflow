# Wraps the passed sources as a collection of HTML <option> tags displaying the
# appropriate text for the :new transfer view
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
  # value
  #
  # @return [Array<String, Integer>]
  def to_a
    sources
      .sort_by do |source|
      [
        source.accountable_type,
        source.accountable.try(:member_uid)
      ]
    end
      .map do |account|
      [
        AccountOptionTag.new(account.accountable, destination_accountable).to_s,
        account.id
      ]
    end
  end

  private

  attr_reader :sources, :destination_accountable
end
