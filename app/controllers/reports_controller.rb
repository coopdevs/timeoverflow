require 'zip'
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

  def all_list
    filename = "#{current_organization.name.gsub(' ', '_')}.zip"
    temp_file = Tempfile.new(filename)
    begin
      Zip::OutputStream.open(temp_file) { |zos| }
      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
        add_csvs_to_zip(%w[Member Transfer Inquiries Offers], zipfile)
      end
      zip_data = File.read(temp_file.path)
      send_data(zip_data, type: 'application/zip', disposition: 'attachment', filename: filename)
    rescue Errno::ENOENT
      redirect_to all_list_report_path
    ensure
      temp_file.close
      temp_file.unlink
    end
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

  def add_csvs_to_zip(report_classes, zip)
    report_classes.each do |report_class|
      collection = return_collection(report_class)
      report = do_report(report_class, collection)
      file = Tempfile.new
      file.write(report.run)
      file.rewind
      zip.add("#{report_class}.csv", file.path)
    end
  end

  def return_collection(report_class)
    case report_class
    when 'Member'
      current_organization.members.active.includes(:user).order('members.member_uid')
    when 'Transfer'
      current_organization.all_transfers_with_accounts
    when 'Inquiries'
      return_collection_posts('Inquiry')
    when 'Offers'
      return_collection_posts('Offer')
    else
      []
    end
  end

  def return_collection_posts(type)
    @post_type = type.constantize
    @posts =  current_organization.posts.of_active_members.active.
              merge(@post_type.all).
              includes(:user, :category).
              group_by(&:category).
              to_a.
              sort_by { |category, _| category.try(:name).to_s }
  end

  def do_report(report_class, collection)
    case report_class
    when 'Inquiries'
      'Report::Csv::Post'.constantize.new(current_organization, collection, 'Inquiry'.constantize)
    when 'Offers'
      'Report::Csv::Post'.constantize.new(current_organization, collection, 'Offer'.constantize)
    else
      "Report::Csv::#{report_class}".constantize.new(current_organization, collection)
    end
  end
end
