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


  def new
    @organization = Organization.new
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

  def give_time
    @destination = @organization.account.id
    @source = current_user.members.find_by(organization: @organization).account.id
    @offer = current_organization.offers.find(params[:offer]) if params[:offer].present?
    @transfer = Transfer.new(source: @source, destination: @destination)
    if admin?
      @sources = [current_organization.account] + current_organization.member_accounts.where("members.active is true")
    end
  end


  private
  def organization_params
    params[:organization].permit(*%w"name theme email phone web public_opening_times description address neighborhood city domain")
  end


end
