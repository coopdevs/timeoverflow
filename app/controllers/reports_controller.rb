class ReportsController < ApplicationController
  before_action :authenticate_user!

  layout "report"

  def user_list
    @members = current_organization.members.active.
               includes(:user).
               order("members.member_uid")

    respond_to do |format|
      format.html
      format.csv do
        report = Report::Csv::Member.new(current_organization, @members)
        send_data report.run, filename: report.name, type: report.mime_type
      end
      format.pdf do
        report = Report::Pdf::Member.new(current_organization, @members)
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
        report = Report::Csv::Post.new(current_organization, @posts, @post_type)
        send_data report.run, filename: report.name, type: report.mime_type
      end
      format.pdf do
        report = Report::Pdf::Post.new(current_organization, @posts, @post_type)
        send_data report.run, filename: report.name, type: report.mime_type
      end
    end
  end

  def transfer_list
    @transfers = current_organization.
                 all_transfers.
                 includes(movements: { account: :accountable }).
                 order("transfers.created_at DESC").
                 uniq

    respond_to do |format|
      format.html
      format.csv do
        report = Report::Csv::Transfer.new(current_organization, @transfers)
        send_data report.run, filename: report.name, type: report.mime_type
      end
      format.pdf do
        report = Report::Pdf::Transfer.new(current_organization, @transfers)
        send_data report.run, filename: report.name, type: report.mime_type
      end
    end
  end
end
