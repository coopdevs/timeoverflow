class TransfersController < ApplicationController
  include WithTransferParams

  def create
    @source = find_source
    @account = Account.find(transfer_params[:destination])

    create_persisters

    if persisters_saved?
      redirect_to redirect_target
    else
      redirect_back fallback_location: redirect_target, alert: @transfer.errors.full_messages.to_sentence
    end
  end

  def new
    transfer_factory = TransferFactory.new(
      current_organization,
      current_user,
      params[:offer],
      params[:destination_account_id],
      params[:organization_id] || current_organization.id
    )

    render(
      :new,
      locals: {
        accountable: transfer_factory.accountable,
        transfer: transfer_factory.build_transfer,
        offer: transfer_factory.offer,
        sources: transfer_factory.transfer_sources
      }
    )
  end

  def delete_reason
    @transfer = Transfer.find(params[:id])
    @transfer.update_columns(reason: nil)

    respond_to do |format|
      format.json { head :ok }
      format.html { redirect_back(fallback_location: request.referer) }
    end
  end

  private

  def find_source
    if admin?
      Account.find(transfer_params[:source])
    else
      current_user.members.find_by(organization: current_organization).account
    end
  end

  def create_persisters
    source_organization = @source.organization.account
    source_type = @source.accountable_type
    destination_organization = @account.organization.account
    @persisters = Array.new
    if source_organization == destination_organization
      transfer_persister_between(@source, @account)
    else
      transfer_persister_between(@source, source_organization) if source_type == "Member"
      transfer_persister_between(source_organization, destination_organization)
      transfer_persister_between(destination_organization, @account)
    end
  end

  def transfer_persister_between(source, destination)
    @transfer = Transfer.new(
      transfer_params.merge(source: source, destination: destination)
    )

    @persisters << ::Persister::TransferPersister.new(@transfer)
  end

  def persisters_saved?
    @persisters.each { |persister| return false if !persister.save }
  end

  def redirect_target
    case accountable = @account.accountable
    when Organization
      accountable
    when Member
      accountable.organization == current_organization ? accountable.user : accountable.organization
    else
      raise ArgumentError
    end
  end
end
