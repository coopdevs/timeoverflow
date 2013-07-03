class OrganizationsController < ApplicationController

  respond_to :json, :html

  before_filter :load_resource

  def load_resource
    if params[:id]
      @organization = Organization.find(params[:id])
    else
      @organizations = Organization.all
    end
  end


  def index
    @organizations = @organizations.matching(params[:q]) if params[:q].present?
    respond_with @organizations
  end

  def show
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
      respond_with @organization
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @organization.destroy
    redirect_to organizations_path, notice: "deleted"
  end

  private
  def organization_params
    params[:organization].permit(*%w"name").tap(&method(:ap))
  end


end
