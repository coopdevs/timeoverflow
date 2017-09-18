class MembersController < ApplicationController
  before_filter :authenticate_user!

  # GET /members
  #
  def index
    context = current_organization
      .members
      .includes(:account, :user)
    context = context.where(active: true) unless (admin? || superadmin?)

    @memberships = context
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

  # DELETE /members/:member_uid
  #
  def destroy
    find_member
    toggle_active_posts
    @member.destroy
    redirect_to members_path
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

  # TODO: move to service and probably different controller
  def give_time
    find_member
    @destination = @member.account.id
    @source = find_transfer_source
    @offer = find_transfer_offer
    @transfer = Transfer.new(
      source: @source,
      destination: @destination,
      post: @offer
    )
    @sources = find_transfer_sources_for_admin
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

  # TODO: move to service and probably different controller
  def find_transfer_offer
    current_organization.offers.
      find(params[:offer]) if params[:offer].present?
  end

  # TODO: move to service and probably different controller
  def find_transfer_source
    current_user.members.
      find_by(organization: current_organization).account.id
  end

  # TODO: move to service and probably different controller
  def find_transfer_sources_for_admin
    return unless admin?
    [current_organization.account] +
      current_organization.member_accounts.where("members.active is true")
  end
end
