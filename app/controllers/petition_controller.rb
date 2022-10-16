class PetitionController < ApplicationController
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
  
  end

  private

  def petition_params
    params.permit(%i[organization_id user_id status])
  end
end
