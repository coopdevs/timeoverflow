class UsersController < ApplicationController
  respond_to :html

  before_filter do
    params[:user] &&= user_params
  end

  # load_and_authorize_resource

  def scoped_users
    return User.none unless current_user
    res = User.scoped
    res = res.where organization_id: current_user.organization_id unless current_user.try :superadmin?
    res
  end


  def index
    respond_with scoped_users.includes(:categories)
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

  def change_password
    @user = scoped_users.find(params[:id])
  end

  def create
    @user = scoped_users.build(user_params)
    unless @user.password.present?
      @user.password = @user.password_confirmation = @user.create_fake_password
    end
    @user.organization_id ||= current_user.organization_id
    @user.assign_registration_number
    if @user.save
      respond_with @user, status: :created, location: @user
    else
      ap @user
      ap @user.errors
      render :new
    end
  end

  def update
    @user = scoped_users.find(params[:id])
    if @user.update_attributes(params[:user])
      respond_with @user, location: @user
    else
      respond_with @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user = scoped_users.find(params[:id])
    @user.destroy
    head :no_content
  end

  private

  def user_params
    fields_to_permit = %w"username email category_ids date_of_birth phone alt_phone password password_confirmation identity_document"
    fields_to_permit += %w"admin registration_number registration_date" if current_user.admin?
    fields_to_permit += %w"organization_id superadmin" if current_user.superadmin?
    params[:user].permit(*fields_to_permit).tap &method(:ap)
  end
end
