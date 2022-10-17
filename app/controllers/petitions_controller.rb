class PetitionsController < ApplicationController
  def create
    petition = Petition.new petition_params

    if petition.save
      flash[:notice] = 'Application sent'
    else
      flash[:error] = 'Something went wrong'
    end

    redirect_to organizations_path
  end
  
  def update
    petition = Petition.find params[:id]
    status = params[:status].to_i
    
    if petition.update(status: status)
      User.find(params[:user_id]).add_to_organization(current_organization) if status == 1
      flash[:notice] = "Application #{Petition::STATUS[status]}"
    else
      flash[:error] = 'Something went wrong'
    end

    redirect_to manage_petitions_path
  end
 
  def manage
    @status = params[:status].to_i
    @users = User.joins(:petitions).where(petitions: { organization_id: current_organization.id, status: @status }).page(params[:page]).per(20)
  end

  private

  def petition_params
    params.permit(%i[organization_id user_id status])
  end
end
