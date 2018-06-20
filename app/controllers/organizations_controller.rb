class OrganizationsController < ApplicationController
  before_filter :load_resource, only: [:show, :edit, :update, :destroy]

  def new
    @organization = Organization.new
  end

  def index
    @organizations = Organization.all
  end

  def show
    @movements = @organization.
                 account.
                 movements.
                 order("created_at DESC").
                 page(params[:page]).
                 per(10)
  end

  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      redirect_to @organization, status: :created
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def update
    if @organization.update_attributes(organization_params)
      redirect_to @organization
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @organization.destroy
    redirect_to organizations_path, notice: "deleted"
  end

  # POST /organizations/:organization_id/set_current
  #
  def set_current
    if current_user
      session[:current_organization_id] = @organization.id
    end
    redirect_to root_path
  end

  private

  def load_resource
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params[:organization].permit(*%w[name theme email phone web
                                     public_opening_times description address
                                     neighborhood city domain])
  end
end
