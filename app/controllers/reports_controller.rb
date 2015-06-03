class ReportsController < ApplicationController
  before_filter :authenticate_user!

  layout "report"

  def user_list
    @members = current_organization.members.active.
               includes(:user).
               order("members.member_uid")

    respond_to do |format|
      format.html
      format.csv do
        report = Report::CSV::Member.new(current_organization, @members)
        send_data report.run, filename: report.name, type: report.mime_type
      end
      format.pdf do
        report = Report::PDF::Member.new(current_organization, @members)
        send_data report.run, filename: report.name, type: report.mime_type
      end
    end
  end

  def post_list
    @post_type = (params[:type] || "offer").capitalize.constantize
    @posts = current_organization.posts.
             of_active_members.
             active.
             merge(@post_type.all).
             includes(:user, :category).
             group_by(&:category).
             to_a.
             sort_by { |category, _| category.try(:name).to_s }

    respond_to do |format|
      format.html
      format.csv do
        report = Report::CSV::Post.new(current_organization, @posts, @post_type)
        send_data report.run, filename: report.name, type: report.mime_type
      end
      format.pdf do
        report = Report::PDF::Post.new(current_organization, @posts, @post_type)
        send_data report.run, filename: report.name, type: report.mime_type
      end
    end
  end
end
