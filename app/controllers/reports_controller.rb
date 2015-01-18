class ReportsController < ApplicationController
  before_filter :authenticate_user!

  layout "report"

  def user_list
    @members = current_organization.members.active.
               includes(:user).
               order("members.member_uid")
  end

  def post_list
    @post_type = (params[:type] || "offer").capitalize.constantize
    @posts = current_organization.posts.with_member.
             where(type: @post_type).
             group_by(&:category).
             to_a.
             sort_by { |category, _| category.try(:name).to_s }
  end
end
