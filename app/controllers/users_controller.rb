class UsersController < ApplicationController
  before_action :authenticate_user!, :member_should_be_active

  has_scope :tagged_with, as: :tag

  def index
    members = current_organization.members.active
    members = apply_scopes(members)

    search_and_load_members members, { s: 'user_last_sign_in_at DESC' }
  end

  def manage
    search_and_load_members current_organization.members, { s: 'member_uid ASC' }
  end

  def show
    @user = find_user
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
    @user.setup_and_save_user

    if @user.persisted?
      @user.tune_after_persisted(current_organization)
      @user.add_tags(current_organization, params[:tag_list] || [])

      redirect_to_after_create
    else
      @user.email = "" if empty_email

      render action: "new"
    end
  end

  def update
    @user = scoped_users.find(params[:id])
    authorize @user

    if @user.update(user_params)
      @user.add_tags(current_organization, params[:tag_list] || [])

      redirect_to @user
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def update_avatar
    avatar = params[:avatar]

    if avatar && content_type_permitted(avatar.content_type)
      current_user.avatar.purge if current_user.avatar.attached?

      crop_image_and_save(current_user, avatar)
    else
      flash[:error] = t 'users.show.invalid_format'
    end

    redirect_to current_user
  end

  private

  def search_and_load_members(members_scope, default_search_params)
    @search = members_scope.ransack(default_search_params.merge(params.to_unsafe_h.fetch(:q, {})))

    result = @search.result
    orders = result.order_values.map { |order| order.direction == :asc ? "#{order.to_sql} NULLS FIRST" : "#{order.to_sql} NULLS LAST" }
    result = result.except(:order).order(orders.join(", ")) if orders.count > 0

    @members = result.eager_load(:account, :user).page(params[:page]).per(20)

    @member_view_models =
      @members.map { |m| MemberDecorator.new(m, self.class.helpers) }
  end

  def scoped_users
    current_organization.users
  end

  def user_params
    fields_to_permit = %w"gender username email date_of_birth phone
                          alt_phone active description notifications push_notifications postcode"
    fields_to_permit += %w"admin registration_number
                           registration_date" if admin?
    fields_to_permit += %w"organization_id superadmin" if superadmin?

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

  def crop_image_and_save(user, avatar)
    orig_width = params[:original_width].to_i
    width      = params[:height_width].to_i
    left       = params[:width_offset].to_i
    top        = params[:height_offset].to_i

    image_processed = ImageProcessing::MiniMagick.
                      source(avatar.tempfile).
                      resize_to_fit(orig_width, nil).
                      crop("#{width}x#{width}+#{left}+#{top}!").
                      convert("png").
                      call

    user.avatar.attach(
      io: image_processed,
      filename: user.username,
      content_type: avatar.content_type
    )
  end

  def content_type_permitted(avatar_content_type)
    %w[image/jpeg image/pjpeg image/png image/x-png].include? avatar_content_type
  end
end
