class TransferSourcesOptions
  def initialize(sources, destination_accountable)
    @sources = sources
    @destination_accountable = destination_accountable
  end

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
