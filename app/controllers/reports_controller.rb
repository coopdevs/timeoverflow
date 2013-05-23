class ReportsController < ApplicationController

  layout "report"

  def user_list
    @users = User.scoped
    @users = @users.where organization_id: current_user.organization_id unless current_user.try :superadmin?
    @users = @users.select("id, registration_number, username, email, phone, alt_phone")
    @users = @users.order("registration_number asc")
  end

  def cat_with_users
    @users = User.scoped
    @users = @users.where organization_id: current_user.organization_id unless current_user.try :superadmin?
    @categories = Category.
      includes(:users, :self_and_ancestors, :self_and_descendants => :users).
      select("categories.name, users.id").
      where('users_categories.id' => @users).sort_by {|c| c.fqn}
    # TODO todavía hay una 1+n aquí...
  end

end

