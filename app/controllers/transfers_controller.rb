class TransfersController < ApplicationController
  def create
    if admin?
      transfer_params = params.require(:transfer).permit(:source, :destination, :amount)
      @source = Account.find(transfer_params[:source])
    else
      transfer_params = params.require(:transfer).permit(:destination, :amount)
      @source = current_user.account
    end
    Transfer.create(transfer_params.merge source: @source)
    redirect_to current_user
  end
end
