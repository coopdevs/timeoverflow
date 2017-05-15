class TransfersController < ApplicationController
  def create
    @source = find_source
    @account = Account.find(transfer_params[:destination])

    transfer_creator = TransferCreator.new(
      source: @source,
      destination: @account,
      amount: transfer_params[:amount],
      reason: transfer_params[:reason],
      post_id: transfer_params[:post_id]
    )
    begin
      transfer_creator.create!
    rescue ActiveRecord::RecordInvalid
      flash[:error] = transfer_creator.transfer.errors.full_messages.to_sentence
    end
    redirect_to redirect_target
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
