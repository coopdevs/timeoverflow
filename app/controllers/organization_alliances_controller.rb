class OrganizationAlliancesController < ApplicationController
  before_action :authenticate_user!
  before_action :member_should_exist_and_be_active
  before_action :authorize_admin
  before_action :find_alliance, only: [:update, :destroy]

  def index
    @status = params[:status] || "pending"

    @alliances = case @status
                 when "pending"
                   current_organization.pending_alliances.includes(:source_organization, :target_organization)
                 when "accepted"
                   current_organization.accepted_alliances.includes(:source_organization, :target_organization)
                 when "rejected"
                   current_organization.rejected_alliances.includes(:source_organization, :target_organization)
                 else
                   []
                 end
  end

  def create
    alliance = OrganizationAlliance.new(
      source_organization: current_organization,
      target_organization_id: alliance_params[:target_organization_id],
      status: "pending"
    )

    if alliance.save
      flash[:notice] = t("organization_alliances.created")
    else
      flash[:error] = alliance.errors.full_messages.to_sentence
    end

    redirect_back fallback_location: organizations_path
  end

  def update
    if @alliance.update(status: params[:status])
      flash[:notice] = t("organization_alliances.updated")
    else
      flash[:error] = @alliance.errors.full_messages.to_sentence
    end

    redirect_to organization_alliances_path
  end

  def destroy
    if @alliance.destroy
      flash[:notice] = t("organization_alliances.destroyed")
    else
      flash[:error] = t("organization_alliances.error_destroying")
    end

    redirect_to organization_alliances_path
  end

  private

  def find_alliance
    @alliance = OrganizationAlliance.find(params[:id])
  end

  def authorize_admin
    return if current_user.manages?(current_organization)

    flash[:error] = t("organization_alliances.not_authorized")
    redirect_to root_path
  end

  def alliance_params
    params.require(:organization_alliance).permit(:target_organization_id)
  end
end
