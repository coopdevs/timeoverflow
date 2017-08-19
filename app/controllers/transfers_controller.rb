class TransfersController < ApplicationController
  def create
    @source = find_source
    @account = Account.find(transfer_params[:destination])
    transfer = Transfer.new(
      transfer_params.merge(source: @source, destination: @account)
    )

    transfer.save!
    redirect_to redirect_target
  rescue ActiveRecord::RecordInvalid
    flash[:error] = transfer.errors.full_messages.to_sentence
  end

  def new
    source = find_transfer_source
    offer = find_transfer_offer
    sources = find_transfer_sources_for_admin
    transfer = build_transfer(offer, source)

    render(
      :new,
      locals: {
        accountable: accountable,
        transfer: transfer,
        offer: offer,
        sources: sources
      }
    )
  end

  def delete_reason
    @transfer = Transfer.find(params[:id])
    @transfer.update_columns(reason: nil)
    respond_to do |format|
      format.json { head :ok }
      format.html { redirect_to :back }
    end
  end

  private

  # Returns a new instance of Transfer with the data provided in the request
  #
  # @return [Transfer]
  def build_transfer(offer, source)
    transfer = Transfer.new(source: source, destination: destination_account.id)
    transfer.post = offer unless for_organization?
    transfer
  end

  # TODO: this method implements authorization by scoping the destination
  # account in all the accounts of the current organization. If the specified
  # destination account does not belong to it, the request will simply faily.
  #
  # Returns the account the time will be transfered to
  #
  # @return [Account]
  def destination_account
    @destination_account ||= current_organization
      .all_accounts
      .find(params[:destination_account_id])
  end

  # Checks whether the destination account is an organization
  #
  # @return [Boolean]
  def for_organization?
    destination_account.accountable.class == Organization
  end

  def accountable
    @accountable ||= destination_account.accountable
  end

  def find_transfer_sources_for_admin
    return unless admin?

    [current_organization.account] +
      current_organization.member_accounts.where("members.active is true")
  end

  # Returns the offer that is the subject of the transfer
  #
  # @return [Offer]
  def find_transfer_offer
    current_organization.offers.
      find(params[:offer]) if params[:offer].present?
  end

  # Returns the id of the account that acts as source of the transfer.
  # Either the account of the organization or the account of the current user.
  #
  # @return [Integer]
  def find_transfer_source
    organization = if accountable.is_a?(Organization)
                     accountable
                   else
                     current_organization
                   end
    current_user.members.find_by(organization: organization).account.id
  end

  def find_source
    if admin?
      Account.find(transfer_params[:source])
    else
      current_user.members.find_by(organization: current_organization).account
    end
  end

  def redirect_target
    case accountable = @account.accountable
    when Organization
      accountable
    when Member
      accountable.user
    else
      raise ArgumentError
    end
  end

  def transfer_params
    params.
      require(:transfer).
      permit(:destination,
             :amount,
             :reason,
             :post_id,
             *[*(:source if admin?)])
  end
end
