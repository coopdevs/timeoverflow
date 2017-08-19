class TransferSourcesOptions
  def initialize(sources, accountable)
    @sources = sources
    @accountable = accountable
  end

  def to_a
    sources
      .sort_by { |source| [source.accountable_type, source.accountable.try(:member_uid)] }
      .map { |a| ["#{a.accountable_type == "Member" ? a.accountable.member_uid : accountable_option_name(a)} #{a.accountable_type} #{a.accountable.to_s}", a.id] }
  end

  private

  attr_reader :sources, :accountable

  def accountable_option_name(account)
    if accountable.is_a?(Organization)
      account.accountable_id
    else
      ''
    end
  end
end
