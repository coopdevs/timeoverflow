class ReportsController < ApplicationController
  before_action :authenticate_user!

  layout "report"

  def user_list
    @members = current_organization.members.active.
               includes(:user).
               order("members.member_uid")

    report_responder('Member', current_organization, @members)
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

    report_responder('Post', current_organization, @posts, @post_type)
  end

  def transfer_list
    @transfers = current_organization.all_transfers_with_accounts

    report_responder('Transfer', current_organization, @transfers)
  end

  private

  def report_responder(report_class, *args)
    respond_to do |format|
      format.html
      format.csv { download_report("Report::Csv::#{report_class}", *args) }
      format.pdf { download_report("Report::Pdf::#{report_class}", *args) }
    end
  end

  def download_report(report_class, *args)
    report = report_class.constantize.new(*args)
    send_data report.run, filename: report.name, type: report.mime_type
  end
end
