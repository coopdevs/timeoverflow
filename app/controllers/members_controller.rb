class MembersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_organization

  # TODO: move to abstract controller for all nested resources
  # TODO: check authorization
  #
  def load_organization
    @organization = Organization.find_by_id(params[:id])

    raise not_found unless @organization

    @organization
  end

  def destroy
    find_member
    toggle_active_posts
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
    if @member.active
      @member.add_all_posts_to_index
    else
      @member.remove_all_posts_from_index
    end
    respond_to do |format|
      format.json { head :ok }
      format.html { redirect_to :back }
    end
  end

  private

  def find_member
    @member ||= @organization.members.find(params[:id])
  end

  def toggle_active_posts
    @organization.posts.where(user_id: @member.user_id).
      each { |post| post.update_attributes(active: false) }
  end
end
