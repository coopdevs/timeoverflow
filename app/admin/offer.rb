ActiveAdmin.register Offer do

  index do
    selectable_column
    id_column
    column :title
    column :description
    column :created_at
    column :user
    column :category
    column :tag_list
    default_actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :title
      f.input :user
      f.input :category
      f.input :description
      f.input :tag_list
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end

end