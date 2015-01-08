class TransfersController < ApplicationController
  def create
    @source = find_source
    Transfer.create(transfer_params.merge source: @source)
    @account = Account.find(transfer_params[:destination])
    redirect_to redirect_target
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
