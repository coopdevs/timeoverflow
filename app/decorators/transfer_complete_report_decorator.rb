class TransferCompleteReportDecorator
  def initialize(org, collection)
    @org = org
    @collection = collection
  end

  def name(extension)
    "#{@org.name}_"\
    "#{Date.today}."\
    "#{extension}"
  end

  def headers
    [
      Transfer.human_attribute_name(:date),
      'from',
      'from ID',
      'to',
      'to ID',
      'post',
      'post ID',
      Transfer.human_attribute_name(:reason),
      'quantity'
    ]
  end

  def rows
    grouped_rows = []

    @collection.each do |transfer|
      row = []
      row << transfer.created_at.to_s
      transfer.movements.sort_by(&:amount).each do |mv|
        mv.account.tap do |account|
          if account.accountable.present?
            if account.accountable_type == 'Organization'
              row << account.accountable.to_s
            elsif account.accountable.active
              row << account.accountable.display_name_with_uid.to_s
            else
              row << 'inactive_user'
            end
          else
            row << 'deleted_user'
          end
        end
        mv.account.tap do |account|
          if account.accountable.present?
            if account.accountable_type == 'Organization'
              row << '0'
            elsif account.accountable.active
              row << account.accountable.display_id.to_s
            else
              row << 'inactive_user'
            end
          else
            row << 'deleted_user'
          end
        end
      end
      row << transfer.post.to_s
      row << transfer.post_id.to_s
      row << transfer.reason.to_s
      row << (transfer.movements.first.amount/3600.0).abs.round(2).to_s
      grouped_rows << row
  end
  grouped_rows
  end
end
