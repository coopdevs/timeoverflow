class TransferFactory
  def initialize(current_organization, current_user, offer_id, destination_account_id,
                 destination_organization_id)
    @current_organization = current_organization
    @current_user = current_user
    @offer_id = offer_id
    @destination_account_id = destination_account_id
    @destination_organization_id = destination_organization_id.to_i
  end

  def destination_organization
    Organization.find(@destination_organization_id)
  end

  # Returns the offer that is the subject of the transfer
  #
  # @return [Maybe<Offer>]
  def offer
    destination_organization.offers.find_by_id(offer_id)
  end

  # Returns a new instance of Transfer with the data provided
  #
  # @return [Transfer]
  def build_transfer
    transfer = Transfer.new(source: source, destination: destination_account.id)
    transfer.post = offer unless for_organization?
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
    @accountable ||= destination_account.accountable
  end

  private

  attr_reader :current_organization, :current_user, :offer_id,
              :destination_account_id

  # Returns the id of the account that acts as source of the transfer.
  # Either the account of the organization or the account of the current user.
  #
  # @return [Maybe<Integer>]
  def source
    organization = if accountable.is_a?(Organization)
                     accountable
                   else
                     current_organization
                   end

    current_user.members.find_by(organization: organization).account.id
  end

  # Checks whether the destination account is an organization
  #
  # @return [Boolean]
  def for_organization?
    destination_account.accountable.class == Organization
  end

  def admin?
    current_user.try :manages?, current_organization
  end

  # TODO: this method implements authorization by scoping the destination
  # account in all the accounts of the current organization. If the specified
  # destination account does not belong to it, the request will simply faily.
  #
  # Returns the account the time will be transfered to
  #
  # @return [Account]
  def destination_account
    @destination_account ||= destination_organization
      .all_accounts
      .find(destination_account_id)
  end
end
