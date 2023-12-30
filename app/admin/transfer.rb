ActiveAdmin.register Transfer do
  includes :post, movements: { account: [:accountable, :organization] }

  actions :index, :destroy

  action_item :upload_csv, only: :index do
    link_to I18n.t("active_admin.users.upload_from_csv"), action: "upload_csv"
  end

  collection_action :upload_csv do
    render "admin/csv/upload_csv"
  end

  collection_action :import_csv, method: :post do
    errors = TransferImporter.call(params[:dump][:organization_id], params[:dump][:file])
    flash[:error] = errors.join("<br/>").html_safe if errors.present?

    redirect_to action: :index
  end

  index do
    id_column
    column :post
    column :reason
    column "From - To" do |transfer|
      accounts_from_movements(transfer, with_links: true).join(" #{glyph(:arrow_right)} ").html_safe
    end
    column :amount do |transfer|
      seconds_to_hm(transfer.movements.first.amount.abs)
    end
    column :created_at do |transfer|
      l transfer.created_at.to_date, format: :long
    end
    column :organization do |transfer|
      transfer.movements.first.account.organization
    end
    actions
  end

  filter :reason
  filter :created_at
end
