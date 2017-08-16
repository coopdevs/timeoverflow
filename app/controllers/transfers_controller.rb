class TransfersController < ApplicationController
  def create
    @source = find_source
    @account = Account.find(transfer_params[:destination])
    transfer = Transfer.new(
      transfer_params.merge(source: @source, destination: @account)
    )

    begin
      transfer.save!
    rescue ActiveRecord::RecordInvalid
      flash[:error] = transfer.errors.full_messages.to_sentence
    end
    redirect_to redirect_target
  end

  def new
    if for_organization?
      load_resource

      @source = find_transfer_source
      @offer = find_transfer_offer
      @destination = @organization.account.id
      @transfer = Transfer.new(source: @source, destination: @destination)
      @sources = find_transfer_sources_for_admin

      render :new_organization
    else
      @user = scoped_users.find(params[:id])
      @destination = @user
        .members
        .find_by(organization: current_organization)
        .account
        .id
      @source = find_transfer_source
      @offer = find_transfer_offer
      @transfer = Transfer.new(
        source: @source,
        destination: @destination,
        post: @offer
      )
      @sources = find_transfer_sources_for_admin
    end
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

  def for_organization?
    params.key?('organization')
  end

  def load_resource
    if params[:id]
      @organization = Organization.find(params[:id])
    else
      @organizations = Organization.all
    end
  end

  def find_transfer_sources_for_admin
    return unless admin?
    [current_organization.account] +
      current_organization.member_accounts.where("members.active is true")
  end

  def find_transfer_offer
    current_organization.offers.
      find(params[:offer]) if params[:offer].present?
  end

  def find_transfer_source
    if for_organization?
      current_user.members.
        find_by(organization: @organization).account.id
    else
      current_user.members.
        find_by(organization: current_organization).account.id
    end
  end

  def scoped_users
    current_organization.users
  end

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
