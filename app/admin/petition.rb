ActiveAdmin.register Petition do
  actions :index

  index do
    id_column
    column :user
    column :organization
    column :created_at
    column :status do |petition|
      petition.status.upcase
    end
  end

  filter :organization
  filter :status, as: :select, collection: -> { Petition.statuses }
  filter :created_at
end
