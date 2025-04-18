class TransferFactory
  def initialize(current_organization, current_user, offer_id, destination_account_id = nil, cross_bank = false)
    @current_organization = current_organization
    @current_user = current_user
    @offer_id = offer_id
    @destination_account_id = destination_account_id
    @cross_bank = cross_bank
  end

  # Returns the offer that is the subject of the transfer
  #
  # @return [Maybe<Offer>]
  def offer
    if offer_id.present?
      Offer.find_by_id(offer_id)
    end
  end

  # Returns a new instance of Transfer with the data provided
  #
  # @return [Transfer]
  def build_transfer
    transfer = Transfer.new(source: source)

    if cross_bank && offer && offer.organization != current_organization
      transfer.destination = destination_organization_account.id
      transfer.post = offer
      transfer.is_cross_bank = true
      transfer.meta = {
        source_organization_id: current_organization.id,
        destination_organization_id: offer.organization.id,
        final_destination_user_id: offer.user.id
      }
    else
      transfer.destination = destination_account.id
      transfer.post = offer unless for_organization?
    end

    transfer
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

  # Returns the id of the account that acts as source of the transfer.
  # Either the account of the organization or the account of the current user.
  #
  # @return [Maybe<Integer>]
  def source
    current_user.members.find_by(organization: current_organization).account.id
  end

  # Checks whether the destination account is an organization
  #
  # @return [Boolean]
  def for_organization?
    destination_account.try(:accountable).class == Organization
  end

  def admin?
    current_user.try :manages?, current_organization
  end

  # Returns the account of the target organization for cross-bank transfers
  #
  # @return [Account]
  def destination_organization_account
    offer.organization.account
  end

  # Returns the account the time will be transfered to
  #
  # @return [Account]
  def destination_account
    @destination_account ||= if destination_account_id
      current_organization.all_accounts.find(destination_account_id)
    elsif offer
      # Get the destination account from the offer's user
      member = offer.user.members.find_by(organization: offer.organization)
      member.account if member
    end
  end
end
