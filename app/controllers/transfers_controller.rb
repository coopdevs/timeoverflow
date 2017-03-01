class TransfersController < ApplicationController
  def create
    @source = find_source
    @account = Account.find(transfer_params[:destination])
    transfer = Transfer.new(
      transfer_params.merge(source: @source, destination: @account)
    )

    begin
      transfer.save!
      #byebug
      # mail notificación pago
      PaymentNotifier.transfer_source(@account.accountable.display_name_with_uid,transfer.amount.to_f/3600).deliver_now
      PaymentNotifier.transfer_destination(@source.accountable.display_name_with_uid,transfer.amount.to_f/3600).deliver_now
    rescue ActiveRecord::RecordInvalid
      flash[:error] = transfer.errors.full_messages.to_sentence
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
