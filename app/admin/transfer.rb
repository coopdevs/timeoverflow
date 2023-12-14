ActiveAdmin.register Transfer do
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
    column :source do |transfer|
      acc = transfer.movements.find_by('amount < 0').account.accountable
      acc.class.name == "Member" ? acc.user : acc
    end
    column :destination do |transfer|
      acc = transfer.movements.find_by('amount > 0').account.accountable
      acc.class.name == "Member" ? acc.user : acc
    end
    column :amount do |transfer|
      transfer.movements.find_by('amount > 0').amount
    end
    column :created_at do |transfer|
      l transfer.created_at.to_date, format: :long
    end
    column :organization do |transfer|
      transfer.movements.first.account.organization
    end
    actions
  end
end
