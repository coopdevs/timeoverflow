class TransfersController < ApplicationController
  def create
    @source = find_source
    @account = Account.find(transfer_params[:destination])

    transfer = Transfer.new(
      transfer_params.merge(source: @source, destination: @account)
    )

    persister = ::Persister::TransferPersister.new(transfer)

    if persister.save
      redirect_to redirect_target
    else
      flash[:error] = transfer.errors.full_messages.to_sentence
    end
  end

  def new
    transfer_factory = TransferFactory.new(
      current_organization,
      current_user,
      params[:offer],
      params[:destination_account_id]
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
      format.html { redirect_to :back }
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
