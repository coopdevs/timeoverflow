class MembersController < ApplicationController
  before_filter :authenticate_user!

  # GET /members
  #
  def index
    search_and_load_members current_organization.members.active, {s: 'member_uid asc'}
  end

  # GET /members/:member_uid
  #
  def show
    find_member
    @user = @member.user
    @movements = @member
      .movements
      .order('created_at DESC')
      .page(params[:page])
      .per(10)
  end

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

  # TODO: rely on organization scope instead of current_organization
  def find_member
    @member ||= Member.where(
      organization_id: current_organization.id,
      member_uid: params[:member_uid]
    ).first

    # TODO: better not found management please
    raise unless @member
  end

  def toggle_active_posts
    current_organization.posts.where(user_id: @member.user_id).
      each { |post| post.update_attributes(active: false) }
  end

  def search_and_load_members(members_scope, default_search_params)
    @search = members_scope.ransack(default_search_params.merge(params.fetch(:q, {})))

    @members =
      @search.result.eager_load(:account, :user).page(params[:page]).per(20)

    @member_view_models =
      @members.map { |m| MemberDecorator.new(m, self.class.helpers) }
  end
end
