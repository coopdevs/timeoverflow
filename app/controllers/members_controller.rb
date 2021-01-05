class MembersController < ApplicationController
  before_action :authenticate_user!

  def destroy
    find_member
    toggle_active_posts
    @member.destroy

    redirect_to manage_users_path
  end

  def toggle_manager
    find_member
    @member.toggle(:manager).save!

    respond_to do |format|
      format.json { head :ok }
      format.html { redirect_to manage_users_path }
    end
  end

  def toggle_active
    find_member
    @member.toggle(:active).save!

    respond_to do |format|
      format.json { head :ok }
      format.html { redirect_to manage_users_path }
    end
  end

  private

  def find_member
    @member ||= current_organization.members.find(params[:id])
  end

  def toggle_active_posts
    current_organization.posts.where(user_id: @member.user_id).
      each { |post| post.update_attributes(active: false) }
  end
end
