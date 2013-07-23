class UsersController < ApplicationController
  respond_to :html


  def scoped_users
    return User.where(id: nil) unless current_user
    res = User.scoped
    res = res.where organization_id: current_user.organization_id unless current_user.try :superadmin?
    res
  end


  def index
    @users = scoped_users
  end

  def show
    @user = scoped_users.find(params[:id])
    respond_with @user
  end

  def new
    @user = scoped_users.build
  end

  def edit
    @user = scoped_users.find(params[:id])
  end

  def create
    @user = scoped_users.build(user_params)
    @user.organization_id ||= current_user.organization_id
    @user.assign_registration_number
    if @user.save
      respond_with @user, status: :created, location: @user
    else
      render action: :new
    end
  end

  def update
    @user = scoped_users.find(params[:id])
    if @user.update_attributes(user_params)
      respond_with @user, location: @user
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = scoped_users.find(params[:id])
    @user.destroy
    head :no_content
  end

  def give_time
    @user = scoped_users.find(params[:id])
    @destination = @user.account.id
    @source = current_user.account.id
    @offer = current_organization.offers.find(params[:offer]) if params[:offer].present?
    @transfer = Transfer.new(source: @source, destination: @destination, post: @offer)
    if admin?
      @sources = [current_organization.account] + current_organization.user_accounts
    end
  end

  private

  def user_params
    fields_to_permit = %w"gender username email date_of_birth phone alt_phone identity_document"
    fields_to_permit += %w"admin registration_number registration_date" if current_user.admin?
    fields_to_permit += %w"organization_id superadmin" if current_user.superadmin?
    # params[:user].permit(*fields_to_permit).tap &method(:ap)
    params.require(:user).permit *fields_to_permit
  end
end
