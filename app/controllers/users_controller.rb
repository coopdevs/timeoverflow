class UsersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js

  def scoped_users
    current_organization.users
  end

  def index
    @users = scoped_users
    @memberships = current_organization.members.
                   where(user_id: @users.map(&:id)).
                   includes(:account).each_with_object({}) do |mem, ob|
                     ob[mem.user_id] = mem
                   end
  end

  def show
    @user = current_user if current_user.id == params[:id].to_i
    @user ||= scoped_users.find(params[:id])
  end

  def new
    authorize User
    @user = scoped_users.build
  end

  def edit
    @user = current_user if current_user.id == params[:id].to_i
    @user ||= scoped_users.find(params[:id])
  end

  def create
    authorize User

    empty_email = false

    if @user = User.find_by_email(user_params[:email])
      reactivate_user
    else
      # New User
      @user = User.new(user_params)
      empty_email = @user.email.empty?
      @user.setup_and_save_user
    end

    if @user.persisted?
      @user.tune_after_persisted(current_organization)
      redirect_to users_path
    else
      @user.email = "" if empty_email
      render action: "new"
    end
  end

  def update
    @user = scoped_users.find(params[:id])
    authorize @user
    if @user.update_attributes(user_params)
      respond_with @user, location: @user
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def give_time
    @user = scoped_users.find(params[:id])
    @destination = @user.members.
                   find_by(organization: current_organization).account.id
    @source = current_user.members.
              find_by(organization: current_organization).account.id
    @offer = current_organization.offers.
             find(params[:offer]) if params[:offer].present?
    @transfer = Transfer.new(source: @source,
                             destination: @destination,
                             post: @offer)
    if admin?
      @sources = [current_organization.account] +
                 current_organization.
                 member_accounts.where("members.active is true")
    end
  end

  def toggle_active
    @user = scoped_users.find(params[:id])
    @user.toggle!(:active)

    if @user.active?
      # Could an admin/superadmin reactivate a user?
    else
      @user.members.delete_all
      # TODO - Inquiries and Offers
    end

    redirect_to action: "index"
  end

  private

  def reactivate_user
    if !@user.active?(current_organization)
      # Deactivated user is registered again (overwrite new attributes)
      @user.attributes = user_params.merge(active: true)
      @user.save!
    end
  end

  def user_params
    fields_to_permit = %w"gender username email date_of_birth phone
                          alt_phone active description"
    fields_to_permit += %w"admin registration_number
                           registration_date" if admin?
    fields_to_permit += %w"organization_id superadmin" if superadmin?
    # params[:user].permit(*fields_to_permit).tap &method(:ap)
    params.require(:user).permit *fields_to_permit
  end
end
