ActiveAdmin.register Post do
  action_item :upload_csv, only: :index do
    link_to I18n.t("active_admin.users.upload_from_csv"), action: "upload_csv"
  end

  collection_action :upload_csv do
    render "admin/csv/upload_csv"
  end

  collection_action :import_csv, method: :post do
    errors = PostImporter.call(params[:dump][:organization_id], params[:dump][:file])
    flash[:error] = errors.join("<br/>").html_safe if errors.present?

    redirect_to action: :index
  end

  index do
    id_column
    column :class
    column :is_group
    column :title
    column :created_at do |post|
      l post.created_at.to_date, format: :long
    end
    column :organization
    column :user
    column :category
    column :tag_list
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.attribute_names
    f.inputs do
      f.input :type, as: :radio, collection: %w[Offer Inquiry]
      f.input :title
      f.input :organization
      f.input :user, hint: "Should be member of the selected organization"
      f.input :category
      f.input :description
      f.input :tag_list, hint: "Accepts comma separated values"
      f.input :is_group
      f.input :active
    end
    f.actions
  end

  permit_params :type, :tag_list, :title, :category_id, :user_id,
    :description, :organization_id, :active, :is_group

  filter :type, as: :select, collection: -> { Post.subclasses }
  filter :id
  filter :title
  filter :organization
  filter :user
  filter :category
  filter :is_group
  filter :active
  filter :created_at
  filter :updated_at
end
