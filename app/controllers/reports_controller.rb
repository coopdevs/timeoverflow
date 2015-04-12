class ReportsController < ApplicationController
  before_filter :authenticate_user!

  layout "report"

  def user_list
    @members = current_organization.members.active.
               includes(:user).
               order("members.member_uid")

    respond_to do |format|
      format.html
      format.csv { send_data Report::CSV::Member.new(@members).run }
      format.pdf { send_data Report::PDF::Member.new(@members).run }
    end
  end

  def post_list
    @post_type = (params[:type] || "offer").capitalize.constantize
    @posts = current_organization.posts.with_member.
             where(type: @post_type).
             group_by(&:category).
             to_a.
             sort_by { |category, _| category.try(:name).to_s }

    respond_to do |format|
      format.html
      format.csv { send_data Report::CSV::Post.new(@posts, @post_type).run }
      format.pdf { send_data Report::PDF::Post.new(@posts, @post_type).run }
    end
  end
end
