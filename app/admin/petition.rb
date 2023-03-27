ActiveAdmin.register Petition do
  actions :index

  index do
    id_column
    column :user
    column :organization
    column :created_at
    column :status
  end

  filter :status, as: :select, collection: -> { Petition.statuses }
  filter :created_at
end
