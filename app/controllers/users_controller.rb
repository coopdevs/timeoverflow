class UsersController < ApplicationController
  before_filter :authenticate_user!

  def scoped_users
    current_organization.users
  end

  # GET /users/:id
  #
  def show
    @user = User.find_by_id(params[:id])
    # TODO: better not found management please
    raise unless @user
    authorize @user
  end

  def new
    authorize User
    @user = scoped_users.build
  end

  def edit
    @user = find_user
  end

  def create
    authorize User

    # New User
    email = user_params[:email]
    @user = User.find_or_initialize_by(email: email) do |u|
      u.attributes = user_params
    end
    empty_email = @user.email.empty?
    @user.setup_and_save_user

    if @user.persisted?
      @user.tune_after_persisted(current_organization)
      redirect_to_after_create
    else
      @user.email = "" if empty_email
      render action: "new"
    end
  end

  def update
    @user = scoped_users.find(params[:id])
    authorize @user

    if @user.update_attributes(user_params)
      redirect_to @user
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    fields_to_permit = %w"gender username email date_of_birth phone
                          alt_phone active description notifications"
    fields_to_permit += %w"admin registration_number
                           registration_date" if admin?
    fields_to_permit += %w"organization_id superadmin" if superadmin?
    # params[:user].permit(*fields_to_permit).tap &method(:ap)
    params.require(:user).permit *fields_to_permit
  end

  def find_user
    if current_user.id == params[:id].to_i
      current_user
    else
      scoped_users.find(params[:id])
    end
  end

  def redirect_to_after_create
    id = @user.member(current_organization).member_uid
    if params[:more]
      redirect_to new_user_path,
                  notice: I18n.t("users.new.user_created_add",
                                 uid: id,
                                 name: @user.username)
    else
      redirect_to users_path,
                  notice: I18n.t("users.index.user_created",
                                 uid: id,
                                 name: @user.username)
    end
  end
end
