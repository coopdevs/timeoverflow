class TransferFactory
  def initialize(current_organization, current_user, offer_id, destination_account_id = nil, cross_bank = false)
    @current_organization = current_organization
    @current_user = current_user
    @offer_id = offer_id
    @destination_account_id = destination_account_id
    @cross_bank = cross_bank
  end

  def offer
    if offer_id.present?
      Offer.find_by_id(offer_id)
    end
  end

  def build_transfer
    transfer = Transfer.new(source: source)

    if cross_bank && offer && offer.organization != current_organization
      transfer.destination = destination_account.id
      transfer.post = offer
      transfer.is_cross_bank = true
    else
      transfer.destination = destination_account.id
      transfer.post = offer unless for_organization?
    end

    transfer
  end

  def source_organization
    current_organization
  end

  def destination_organization
    offer&.organization
  end

  def final_destination_user
    offer&.user
  end

  def transfer_sources
    if admin?
      [current_organization.account] +
        current_organization.member_accounts.merge(Member.active)
    else
      []
    end
  end

  def accountable
    @accountable ||= destination_account.try(:accountable)
  end

  private

  attr_reader :current_organization, :current_user, :offer_id,
              :destination_account_id, :cross_bank

  def source
    current_user.members.find_by(organization: current_organization).account.id
  end

  def for_organization?
    destination_account.try(:accountable).class == Organization
  end

  def admin?
    current_user.try :manages?, current_organization
  end

  def destination_organization_account
    offer.organization.account
  end

  def destination_account
    @destination_account ||= if destination_account_id
      current_organization.all_accounts.find(destination_account_id)
    elsif offer
      member = offer.user.members.find_by(organization: offer.organization)
      member.account if member
    end
  end
end
