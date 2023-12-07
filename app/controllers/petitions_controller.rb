class PetitionsController < ApplicationController
  before_action :authenticate_user!

  def create
    petition = Petition.new petition_params
    petition.status = "pending"

    if petition.save
      OrganizationNotifier.new_petition(petition).deliver_now
      OrganizationNotifier.petition_sent(petition).deliver_now

      flash[:notice] = t('petitions.application_status', status: t("petitions.status.sent"))
    else
      flash[:error] = t('errors.internal_server_error.description')
    end

    redirect_back fallback_location: organization_path(petition.organization)
  end

  def update
    petition = Petition.find params[:id]
    status = params[:status]

    if petition.update(status: status)
      petition.user.add_to_organization(petition.organization) if status == 'accepted'
      flash[:notice] = t('petitions.application_status', status: t("petitions.status.#{status}"))
    else
      flash[:error] = t('errors.internal_server_error.description')
    end

    redirect_to manage_petitions_path
  end

  def manage
    @status = params[:status] || 'pending'
    @users = User.joins(:petitions).where(petitions: { organization_id: current_organization.id, status: @status }).page(params[:page]).per(20)
  end

  private

  def petition_params
    params.permit(%i[organization_id user_id])
  end
end
