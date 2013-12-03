class UsersController < ApplicationController
  respond_to :html, :js

  def scoped_users
    return User.none unless current_user
    current_organization.users
  end


  def index
    @users = scoped_users
    @users = @users.fuzzy_search(params[:q]) if params[:q].present?
    @users = @users.page(params[:page]).per(10)
  end

  def show
    @user = scoped_users.find(params[:id])
  end

  def new
    @user = scoped_users.build
  end

  def edit
    @user = scoped_users.find(params[:id])
  end

  def create
    @user = scoped_users.build(user_params)

    if @user.save
      @user.members.create(:organization => current_organization) do |member|
        member.entry_date = DateTime.now.utc
      end

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
    @destination = @user.members.find_by(organization: current_organization).account.id
    @source = current_user.members.find_by(organization: current_organization).account.id
    @offer = current_organization.offers.find(params[:offer]) if params[:offer].present?
    @transfer = Transfer.new(source: @source, destination: @destination, post: @offer)
    if admin?
      @sources = [current_organization.account] + current_organization.member_accounts
    end
  end

  private

  def user_params
    fields_to_permit = %w"gender username email date_of_birth phone alt_phone identity_document"
    fields_to_permit += %w"admin registration_number registration_date" if admin?
    fields_to_permit += %w"organization_id superadmin" if superadmin?
    # params[:user].permit(*fields_to_permit).tap &method(:ap)
    params.require(:user).permit *fields_to_permit
  end
end
