class TransfersController < ApplicationController
  def create
    # ap ["Logged user", current_user.username]
    # ap ["Current organization", current_organization.name]

    if admin?
      transfer_params = params.require(:transfer).permit(:source, :destination, :amount, :reason)
      @source = Account.find(transfer_params[:source])
    else
      transfer_params = params.require(:transfer).permit(:destination, :amount, :reason)
      @source = current_user.members.find_by(organization: current_organization).account
    end

    # ap transfer_params
    # ap @source
    # ap Account.find(transfer_params[:destination])
    Transfer.create(transfer_params.merge source: @source)
    redirect_to current_user
  end
end
