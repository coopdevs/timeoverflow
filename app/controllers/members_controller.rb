class MembersController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @member = Member.find(params[:id])
    toggle_active_posts
    @member.destroy

    OrganizationNotifier.member_deleted(@member.user.username, current_organization).deliver_later

    redirect_to request.referer.include?(organizations_path) ? organizations_path : manage_users_path
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
      each { |post| post.update(active: false) }
  end
end
