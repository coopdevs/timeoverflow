class OrganizationTransfersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_manager_role
  before_action :set_organizations, only: [:new]
  before_action :validate_alliance, only: [:new, :create]

  def new
    @transfer = Transfer.new
  end

  def create
    @transfer = Transfer.new(transfer_params)
    @transfer.source = current_organization.account
    @transfer.destination = destination_organization.account
    @transfer.post = nil
    persister = ::Persister::TransferPersister.new(@transfer)

    if persister.save
      redirect_to organization_path(destination_organization),
                  notice: t('organizations.transfers.create.success')
    else
      set_organizations
      flash.now[:error] = t('organizations.transfers.create.error', error: @transfer.errors.full_messages.to_sentence)
      render :new
    end
  end

  private

  def transfer_params
    params.require(:transfer).permit(:amount, :hours, :minutes, :reason)
  end

  def check_manager_role
    unless current_user.manages?(current_organization)
      redirect_to root_path, alert: t('organization_alliances.not_authorized')
    end
  end

  def set_organizations
    @source_organization = current_organization
    @destination_organization = destination_organization
  end

  def destination_organization
    @destination_organization ||= Organization.find(params[:destination_organization_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to organizations_path, alert: t('application.tips.user_not_found')
  end

  def validate_alliance
    alliance = current_organization.alliance_with(destination_organization)
    unless alliance && alliance.accepted?
      redirect_to organizations_path,
                  alert: t('transfers.cross_bank.no_alliance')
    end
  end
end
