ActiveAdmin.register Petition do
  actions :index, :destroy

  controller do
    def destroy
      if resource.accepted?
        redirect_to admin_petitions_path, alert: "ACCEPTED petitions can't be deleted"
      else
        super
      end
    end
  end

  index do
    id_column
    column :user
    column :organization
    column :created_at
    column :status do |petition|
      petition.status.upcase
    end
    actions
  end

  filter :organization
  filter :status, as: :select, collection: -> { Petition.statuses }
  filter :created_at
  filter :updated_at
end
