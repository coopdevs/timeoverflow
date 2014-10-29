class TransfersController < ApplicationController
  def create
    @source = if admin?
      Account.find(transfer_params[:source])
    else
      current_user.members.find_by(organization: current_organization).account
    end
    Transfer.create(transfer_params.merge source: @source)
    redirect_to Account.find(transfer_params[:destination]).accountable
  end

  private

    def transfer_params
      params.require(:transfer).permit(*[:destination, :amount, :reason, :post_id, (:source if admin?)].compact)
    end
end
