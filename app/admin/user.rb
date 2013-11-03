ActiveAdmin.register User do
  index do
    column do |user|
      link_to image_tag(avatar_url(user, 24)), admin_user_path(user)
    end
    column :username
    column :email
    column :organization
    default_actions
  end

  filter :organization
  filter :email
  filter :username

  form do |f|
    f.inputs "Admin Details" do
      f.input :username
      f.input :email
      f.input :organization
      f.input :gender
      f.input :identity_document
    end
    f.actions
  end
  controller do
    def permitted_params
      params.permit!
    end
  end
end
