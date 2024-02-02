class UsersController < ApplicationController
  before_action :authenticate_user!, except: %i[signup create]
  before_action :user_should_be_confirmed, except: %i[signup create please_confirm]
  before_action :member_should_exist_and_be_active,
                except: %i[signup create edit show update please_confirm]

  has_scope :tagged_with, as: :tag

  def index
    members = current_organization.members.active
    members = apply_scopes(members)

    search_and_load_members members, { s: "user_last_sign_in_at DESC" }
  end

  def manage
    search_and_load_members current_organization.members, { s: "member_uid ASC" }
  end

  def show
    @user = find_user
    redirect_to edit_user_path(@user) and return if !current_organization

    @member = @user.as_member_of(current_organization)
    @movements = @member.movements.order("created_at DESC").page(params[:page]).
                 per(10)
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

    email = user_params[:email]
    @user = User.find_or_initialize_by(email: email) do |u|
      u.attributes = user_params
    end
    empty_email = @user.email.empty?
    @user.from_signup = params[:from_signup].present?
    @user.setup_and_save_user

    if @user.persisted?
      unless @user.from_signup
        @user.tune_after_persisted(current_organization)
        @user.add_tags(current_organization, params[:tag_list] || [])
      end

      redirect_to_after_create
    else
      @user.email = "" if empty_email

      render action: @user.from_signup ? "signup" : "new"
    end
  end

  def update
    @user = User.find(params[:id])
    authorize @user unless @user == current_user

    if @user.update(user_params)
      @user.add_tags(current_organization, params[:tag_list] || []) if current_organization

      redirect_to @user
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def signup
    redirect_to root_path and return if current_user

    @user = User.new
  end

  def update_avatar
    operation = AvatarGenerator.new(current_user, params)

    if operation.errors.empty?
      operation.call
    else
      flash[:error] = operation.errors.join("<br>")
    end

    redirect_to current_user
  end

  def please_confirm; end

  private

  def search_and_load_members(members_scope, default_search_params)
    @search = members_scope.ransack(default_search_params.merge(params.to_unsafe_h.fetch(:q, {})))

    result = @search.result
    orders = result.order_values.map do |order|
      order.direction == :asc ? "#{order.to_sql} NULLS FIRST" : "#{order.to_sql} NULLS LAST"
    end
    result = result.except(:order).order(orders.join(", ")) if orders.count > 0

    @members = result.eager_load(:account, :user).page(params[:page]).per(20)

    @member_view_models =
      @members.map { |m| MemberDecorator.new(m, self.class.helpers) }
  end

  def scoped_users
    current_organization.users
  end

  def user_params
    fields_to_permit = %w"gender username email date_of_birth phone alt_phone active
                          locale description notifications push_notifications postcode"
    if admin?
      fields_to_permit += %w"admin registration_number
                             registration_date"
    end
    fields_to_permit += %w"organization_id superadmin" if superadmin?
    fields_to_permit += %w"password" if params[:from_signup].present?

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
    if params[:from_signup].present?
      sign_in(@user)
      redirect_to terms_path
    else
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
end
