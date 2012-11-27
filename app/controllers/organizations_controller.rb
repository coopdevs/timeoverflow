class OrganizationsController < ApplicationController

  respond_to :json

  before_filter do
    params[:organization] &&= organization_params
  end

  load_and_authorize_resource


  def index
    respond_with @organizations
  end

  def show
    respond_with @organization
  end

  def create
    if @organization.save
      render json: @organization, status: :created, location: @organization
    else
      render json: @organization.errors, status: :unprocessable_entity
    end
  end

  def update
    if @organization.update_attributes(params[:organization])
      respond_with @organization
    else
      render json: @organization.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @organization.destroy
    head :no_content
  end

  private
  def organization_params
    params[:organization].permit(*%w"name").tap(&method(:ap))
  end


end
