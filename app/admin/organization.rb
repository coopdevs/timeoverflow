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

  controller do
    def destroy
      resource.destroy

      if resource == current_organization
        sign_out_and_redirect(current_user)
      else
        redirect_to admin_organizations_path
      end
    end
  end

  filter :id
  filter :name
  filter :web
  filter :phone
  filter :city, as: :select, collection: -> { Organization.pluck(:city).uniq }
  filter :neighborhood

  permit_params :name, :email, :web, :phone, :city, :neighborhood,
    :address, :description, :public_opening_times
end
