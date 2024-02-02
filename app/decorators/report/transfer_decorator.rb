class Report::TransferDecorator
  include Rails.application.routes.url_helpers
  include ActionView::Helpers
  include TransfersHelper
  include ApplicationHelper

  def initialize(org, collection)
    @org = org
    @collection = collection
  end

  def name(extension)
    "#{@org.name}_"\
    "#{Transfer.model_name.human(count: :many)}_"\
    "#{Date.today}."\
    "#{extension}"
  end

  def headers
    [
      I18n.t("statistics.all_transfers.date"),
      I18n.t("statistics.all_transfers.from"),
      I18n.t("statistics.all_transfers.to"),
      I18n.t("statistics.all_transfers.post"),
      I18n.t("statistics.all_transfers.quantity")
    ]
  end

  def rows
    @collection.map do |transfer|
      [
        transfer.created_at.to_s,
        accounts_from_movements(transfer),
        transfer.post.to_s,
        seconds_to_hm(transfer.movements.first.amount.abs, 0)
      ].flatten
    end
  end
end
