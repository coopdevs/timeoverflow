class UsersController < ApplicationController

  def scoped_users
    return User.none unless current_user
    res = User.all
    res = res.where organization_id: current_organization unless superadmin?
    res
  end


  def index
    @users = scoped_users
  end

  def show
    @user = scoped_users.find(params[:id])
  end

  def new
    @user = scoped_users.build user_defaults
  end

  def edit
    @user = scoped_users.find(params[:id])
  end

  def create
    @user = scoped_users.build(user_defaults.merge user_params)
    @user.organization_id ||= current_user.organization_id
    @user.assign_registration_number
    if @user.save
      redirect_to @user
      # respond_with @user, status: :created, location: @user
    else
      redirect_to :action => "new"
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

  def user_defaults
    {
      registration_date: Date.today
    }
  end

  def user_params
    fields_to_permit = %w"gender username email date_of_birth phone alt_phone identity_document"
    fields_to_permit += %w"admin registration_number registration_date" if current_user.admin?
    fields_to_permit += %w"organization_id superadmin" if current_user.superadmin?
    # params[:user].permit(*fields_to_permit).tap &method(:ap)
    params.require(:user).permit *fields_to_permit
  end
end
