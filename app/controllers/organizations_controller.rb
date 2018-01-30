class OrganizationsController < ApplicationController
  before_filter :load_resource

  def load_resource
    if params[:id]
      @organization = Organization.find(params[:id])
    else
      @organizations = Organization.all
    end
  end

  def new
    @organization = Organization.new
  end

  def index
    @organizations = @organizations.matching(params[:q]) if params[:q].present?
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
    @organization = @organizations.build organization_params
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

  def set_current
    if current_user
      session[:current_organization_id] = @organization.id
    end
    redirect_to root_path
  end

  private

  def organization_params
    params[:organization].permit(*%w[name theme email phone web
                                     public_opening_times description address
                                     neighborhood city domain])
  end
end
