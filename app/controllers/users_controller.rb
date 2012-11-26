class UsersController < ApplicationController
  respond_to :json
  # GET /users
  # GET /users.json
  def index
    @users = User.all
    respond_with @users
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    respond_with @user
  end


  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      respond_with @user, status: :created, location: @user
    else
      respond_with @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      respond_with @user, location: @user
    else
      respond_with @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    head 204
  end

  private

  # Use this method to whitelist the permissible parameters. Example: params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def user_params
    params[:user].permit *%w"username email category_ids date_of_birth phone alt_phone password password_confirmation"
  end
end
