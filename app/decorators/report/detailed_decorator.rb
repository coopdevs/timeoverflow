class Report::DetailedDecorator
  include TransfersHelper

  def initialize(org)
    @org = org
  end

  def name(extension)
    "#{@org.name.parameterize}_"\
    "#{Date.today}."\
    "#{I18n.t('global.detailed')}_"\
    ".#{extension}"
  end

  def headers
    ["#{@org.name} #{I18n.t('global.detailed')}"]
  end

  def rows
    make_table(Organization, organization_header, organization_row) +
      make_table(User, member_headers, member_rows) +
      make_table(Account, account_headers, account_rows) +
      make_table(Post, post_headers, post_rows) +
      make_table(Transfer, transfer_headers, transfer_rows)
  end

  private

  def organization_header
    make_headers(Organization, %w[reg_number_seq])
  end

  def organization_row
    make_rows(Organization, %w[reg_number_seq], [@org])
  end

  def member_headers
    excluded_users = %w[id encrypted_password reset_password_token reset_password_token
                        reset_password_sent_at current_sign_in_ip last_sign_in_ip confirmation_token
                        remember_created_at unconfirmed_email unlock_token locked_at notifications
                        push_notifications created_at updated_at active]
    excluded_members = %w[user_id organization_id member_uid]

    make_headers(Member, excluded_members) +
      make_headers(User, excluded_users)
  end

  def member_rows
    excluded_users = %w[id encrypted_password reset_password_token reset_password_token
                        reset_password_sent_at current_sign_in_ip last_sign_in_ip confirmation_token
                        remember_created_at unconfirmed_email unlock_token locked_at notifications
                        push_notifications created_at updated_at active]
    user_rows = make_rows(User, excluded_users, @org.users)
    @org.members.each_with_index.map do |member, ix|
      [member.member_uid,
       member.manager,
       member.created_at,
       member.updated_at,
       member.entry_date,
       member.active,
       member.tag_list.to_s] + user_rows[ix]
    end
  end

  def account_headers
    make_headers(Account, %w[max_allowed_balance min_allowed_balance updated_at organization_id])
  end

  def account_rows
    make_rows(Account, %w[max_allowed_balance min_allowed_balance updated_at organization_id],
              Account.where(organization: @org))
  end

  def post_headers
    make_headers(Post, %w[tsv])
  end

  def post_rows
    make_rows(Post, %w[tsv], @org.posts.map)
  end

  def transfer_headers
    headers = []
    excluded = %w[operator_id updated_at created_at]
    Transfer.columns.each { |col| headers << col.name if !excluded.include?(col.name) }
    headers + [
      I18n.t('statistics.all_transfers.from'),
      "#{I18n.t('statistics.all_transfers.from')}_#{I18n.t('statistics.all_transfers.type')}",
      I18n.t('statistics.all_transfers.to'),
      "#{I18n.t('statistics.all_transfers.to')}_#{I18n.t('statistics.all_transfers.type')}",
      I18n.t('statistics.all_transfers.quantity'),
      I18n.t('statistics.all_transfers.date')
    ]
  end

  def transfer_rows
    @org.all_transfers_with_accounts.map do |transfer|
      [transfer.id,
       transfer.post_id,
       transfer.reason,
       accounts_from_movements_id(transfer),
       transfer.movements.first.amount.abs,
       transfer.created_at.to_s].flatten
    end
  end

  def make_table(table, header, rows)
    [[table.model_name.human]] + [header] + rows
  end

  def make_headers(table, excluded)
    table.columns.map { |col| table.human_attribute_name(col.name) if !excluded.include?(col.name) }.
      grep(String)
  end

  def make_rows(table, excluded, collection)
    collection.map do |single|
      table.columns.map do |col|
        get_value_column(col.name, single, excluded)
      end.grep(String)
    end
  end

  def get_value_column(col_name, single, excluded)
    if col_name == 'tags'
      single.tag_list.to_s
    elsif col_name == 'accountable_id' && single.accountable_type == 'Member'
      single.accountable.member_uid.to_s
    elsif col_name == 'category_id'
      single.category.to_s
    elsif !excluded.include?(col_name)
      single[col_name].to_s.truncate(60)
    end
  end
end
