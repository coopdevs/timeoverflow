ActiveAdmin.register User do
  index do
    column do |user|
      link_to image_tag(avatar_url(user, 24)), admin_user_path(user)
    end
    column :email
    column :username
    column :organization
    column :superadmin
    default_actions
  end

  filter :organization
  filter :email
  filter :username

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :organization
    end
    f.actions
  end
  controller do
    def permitted_params
      params.permit admin_user: [:email, :organization_id]
    end
  end
end
