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
    transfer_factory = TransferFactory.new(
      current_organization,
      current_user,
      params[:offer],
      params[:destination_account_id]
    )

    offer = transfer_factory.offer
    transfer = transfer_factory.build_transfer
    transfer_sources = transfer_factory.transfer_sources
    accountable = transfer_factory.accountable

    render(
      :new,
      locals: {
        accountable: accountable,
        transfer: transfer,
        offer: offer,
        sources: transfer_sources
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
