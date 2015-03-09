class MembersController < ApplicationController
  before_filter :authenticate_user!

  def destroy
    find_member
    current_organization.posts.where(user_id: @member.user_id).destroy_all
    @member.destroy
    redirect_to users_path
  end

  def toggle_manager
    find_member
    @member.toggle(:manager).save!
    respond_to do |format|
      format.json { head :ok }
      format.html { redirect_to :back }
    end
  end

  def toggle_active
    find_member
    @member.toggle(:active).save!
    respond_to do |format|
      format.json { head :ok }
      format.html { redirect_to :back }
    end
  end

  private

  def find_member
    @member ||= current_organization.members.find(params[:id])
  end
end
