class TransfersController < ApplicationController
  def create
    @source = if admin?
      Account.find(transfer_params[:source])
    else
      current_user.members.find_by(organization: current_organization).account
    end
    Transfer.create(transfer_params.merge source: @source)
    account = Account.find(transfer_params[:destination])
    redirect_to account.accountable_type == "Organization" ? account.accountable : account.accountable.user
  end

  private

    def transfer_params
      params.require(:transfer).permit(*[:destination, :amount, :reason, :post_id, (:source if admin?)].compact)
    end
end
