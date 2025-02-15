ActiveAdmin.register Organization do
  index do
    id_column
    column :name do |organization|
      output = tag.p organization.name

      if organization.logo.attached?
        output << image_tag(organization.logo.variant(resize_to_fill: [40, nil]))
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
    column :posts do |organization|
      organization.posts.count
    end
    column :highlighted
    actions
  end

  show do
    div do
      if organization.logo.attached?
        image_tag(organization.logo.variant(resize_to_fill: [100, nil]))
      end
    end
    default_main_content
  end

  form do |f|
    f.inputs do
      f.input :highlighted, hint: "Highlighted Time Banks will appear first"
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
  filter :created_at
  filter :updated_at
  filter :highlighted

  permit_params :name, :email, :web, :phone, :city, :neighborhood,
    :address, :description, :public_opening_times, :logo, :highlighted
end
