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
    @transfers = current_organization.
                 all_transfers.
                 includes(movements: { account: :accountable }).
                 order("transfers.created_at DESC").
                 uniq

    report_responder('Transfer', current_organization, @transfers)
  end

  private

  def report_responder(report_class, *args)
    respond_to do |format|
      format.html
      format.csv do
        report = Report::Csv.const_get(report_class).new(*args)
        send_data report.run, filename: report.name, type: report.mime_type
      end
      format.pdf do
        report = Report::Pdf.const_get(report_class).new(*args)
        send_data report.run, filename: report.name, type: report.mime_type
      end
    end
  end
end
