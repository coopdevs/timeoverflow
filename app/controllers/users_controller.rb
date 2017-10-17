class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_organization, only: [:index]

  # TODO: move to abstract controller for all nested resources
  def load_organization
    @organization = Organization.find_by_id(params[:organization_id])

    raise not_found unless @organization

    @organization
  end

  def scoped_users
    @organization.users
  end

  # GET /organizations/:id/members
  #
  def index
    authorize @organization, :show?

    @users = scoped_users
    @memberships = @organization.members.
                   where(user_id: @users.map(&:id)).
                   includes(:account).each_with_object({}) do |mem, ob|
                     ob[mem.user_id] = mem
                   end
  end

  # GET /members/:user_id
  #
  def show
    authorize @organization, :show?

    @user = find_user
    authorize @user

    @member = @user.as_member_of(@organization)
    @movements = @member.movements.order("created_at DESC").page(params[:page]).
                 per(10)
  end

  def new
    authorize @organization, :admin?

    @user = scoped_users.build
  end

  def edit
    @user = User.find_by_id(params[:id])

    # TODO: raise 404
    raise unless @user

    authorize @user
  end

  def create
    # New User
    email = user_params[:email]
    @user = User.find_or_initialize_by(email: email) do |u|
      u.attributes = user_params
    end
    empty_email = @user.email.empty?
    @user.setup_and_save_user

    if @user.persisted?
      @user.tune_after_persisted(@organization)
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

  def give_time
    @user = scoped_users.find(params[:id])
    @destination = @user.members.
                   find_by(organization: @organization).account.id
    @source = find_transfer_source
    @offer = find_transfer_offer
    @transfer = Transfer.new(source: @source,
                             destination: @destination,
                             post: @offer)
    @sources = find_transfer_sources_for_admin
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

  def find_transfer_offer
    @organization.offers.
      find(params[:offer]) if params[:offer].present?
  end

  def find_transfer_source
    current_user.members.
      find_by(organization: @organization).account.id
  end

  def find_transfer_sources_for_admin
    return unless admin?
    [@organization.account] +
      @organization.member_accounts.where("members.active is true")
  end

  def find_user
    if current_user.id == params[:id].to_i
      current_user
    else
      scoped_users.find(params[:id])
    end
  end

  def redirect_to_after_create
    id = @user.member(@organization).member_uid
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
