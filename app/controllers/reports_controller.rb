class ReportsController < ApplicationController

  layout "report"

  def user_list
    @users = User.all
    @users = @users.where organization_id: current_user.organization_id unless current_user.try :superadmin?
    @users = @users.select("id, registration_number, username, email, phone, alt_phone")
    @users = @users.order("registration_number asc")
  end

  def cat_with_users
    @offers = current_organization.offers.group_by(&:category)
  end

end

