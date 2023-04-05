ActiveAdmin.register Organization do
  index do
    id_column
    column :name do |organization|
      output = tag.p organization.name

      if organization.logo.attached?
        output << image_tag(organization.logo.variant(resize: "40^x"))
      end

      output.html_safe
    end
    column :created_at do |organization|
      l organization.created_at.to_date, format: :long
    end
    column :city
    column :neighborhood
    column :email
    column :phone
    column :members do |organization|
      organization.members.count
    end
    actions
  end

  show do
    div do
      if organization.logo.attached?
        image_tag(organization.logo.variant(resize: "100^x"))
      end
    end
    default_main_content
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
      f.input :logo, as: :file
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
    :address, :description, :public_opening_times, :logo
end
