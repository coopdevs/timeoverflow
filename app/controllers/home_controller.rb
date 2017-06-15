class HomeController < ApplicationController

  # TODO: what happens when the user doesn't pertain to any organization?
  def index
    return unless current_user

    organization_id = current_user.organization_ids.first

    redirect_to organization_path(id: organization_id)
  end
end
