class OrganizationsController < ApplicationController
  before_action :load_resource, only: [:show, :edit, :update, :set_current]

  def index
    @organizations = Organization.all.page(params[:page]).per(25)
  end

  def show
    @movements = @organization.
                 account.
                 movements.
                 order("created_at DESC").
                 page(params[:page]).
                 per(10)
  end

  def update
    if @organization.update(organization_params)
      redirect_to @organization
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  # POST /organizations/:organization_id/set_current
  #
  def set_current
    if current_user
      session[:current_organization_id] = @organization.id
    end
    redirect_to root_path
  end

  def select_organization
    @organizations = current_user.organizations
  end

  private

  def load_resource
    @organization = Organization.find(params[:id])

    authorize @organization
  end

  def organization_params
    params[:organization].permit(*%w[name theme email phone web
                                     public_opening_times description address
                                     neighborhood city domain])
  end
end
