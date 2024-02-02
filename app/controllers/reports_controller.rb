require "zip"

class ReportsController < ApplicationController
  before_action :authenticate_user!

  layout "report"

  def user_list
    @members = report_collection("Member")

    report_responder("Member", current_organization, @members)
  end

  def post_list
    @post_type = (params[:type] || "offer").capitalize.constantize
    @posts = report_collection(@post_type)

    report_responder("Post", current_organization, @posts, @post_type)
  end

  def transfer_list
    @transfers = report_collection("Transfer")

    report_responder("Transfer", current_organization, @transfers)
  end

  def download_all
    filename = "#{current_organization.name.parameterize}_#{Date.today}.zip"
    temp_file = Tempfile.new(filename)

    begin
      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
        %w(Member Transfer Inquiry Offer).each do |report_class|
          add_csv_to_zip(report_class, zipfile)
        end
      end
      zip_data = File.read(temp_file.path)
      send_data(zip_data, type: "application/zip", disposition: "attachment", filename: filename)
    rescue Errno::ENOENT
      redirect_to download_all_report_path
    ensure
      temp_file.close
      temp_file.unlink
    end
  end

  private

  def report_responder(report_class, *args)
    respond_to do |format|
      format.html
      format.csv { download_report("Csv::#{report_class}", *args) }
      format.pdf { download_report("Pdf::#{report_class}", *args) }
    end
  end

  def download_report(report_class, *args)
    report = get_report(report_class, *args)
    send_data report.run, filename: report.name, type: report.mime_type
  end

  def get_report(report_class, *args)
    "Report::#{report_class}".constantize.new(*args)
  end

  def report_collection(report_class)
    case report_class.to_s
    when "Member"
      current_organization.members.active.includes(:user).order("members.member_uid")
    when "Transfer"
      current_organization.all_transfers_with_accounts
    when "Inquiry", "Offer"
      report_class = report_class.constantize if report_class.is_a?(String)

      current_organization.posts.of_active_members.active.
        merge(report_class.all).
        includes(:user, :category).
        group_by(&:category).
        sort_by { |category, _| category.try(:name).to_s }
    end
  end

  def add_csv_to_zip(report_class, zip)
    collection = report_collection(report_class)

    report = if report_class.in? %w(Inquiry Offer)
               get_report("Csv::Post", current_organization, collection, report_class.constantize)
             else
               get_report("Csv::#{report_class}", current_organization, collection)
             end

    file = Tempfile.new
    file.write(report.run)
    file.rewind

    zip.add("#{report_class.pluralize}_#{Date.today}.csv", file.path)
  end
end
