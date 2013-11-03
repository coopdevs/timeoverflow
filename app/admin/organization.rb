ActiveAdmin.register Organization do
  index do
    id_column
    column :name
    column :created_at
    column :updated_at
    # column :email
    # column :domain
    default_actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :name
      # f.input :email
      # f.input :domain
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end
