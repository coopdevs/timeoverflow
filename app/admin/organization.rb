ActiveAdmin.register Organization do
  index do
    id_column
    column :name
    column :created_at do |organization|
      l organization.created_at.to_date, format: :long
    end
    column :city
    column :neighborhood
    column :email
    column :phone
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :web
      f.input :phone
      f.input :city
      f.input :neighborhood
      f.input :address
      f.input :description
      f.input :public_opening_times
    end
    f.actions
  end

  filter :name
  filter :city, as: :select, collection: -> { Organization.pluck(:city).uniq }
  filter :neighborhood

  permit_params *Organization.attribute_names
end
