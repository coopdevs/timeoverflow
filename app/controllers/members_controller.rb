class MembersController < ApplicationController
  before_filter :authenticate_user!

  def destroy
    user_id = Member.find(params[:id]).user_id
    current_organization.members.find(params[:id]).destroy
    current_organization.posts.where(user_id: user_id).destroy_all
    redirect_to users_path
  end

  def toggle_manager
    current_organization.members.find(params[:id]).toggle(:manager).save!
    respond_to do |format|
      format.json { head :ok }
      format.html { redirect_to :back }
    end
  end

  def toggle_active
    current_organization.members.find(params[:id]).toggle(:active).save!
    respond_to do |format|
      format.json { head :ok }
      format.html { redirect_to :back }
    end
  end

end
