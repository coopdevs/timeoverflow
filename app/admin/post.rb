ActiveAdmin.register Post do
  index do
    selectable_column
    id_column
    column :class
    column :title
    column :created_at do |post|
      l post.created_at.to_date, format: :long
    end
    column :user
    column :category
    column :tag_list
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Admin Details" do
      f.input :type, as: :select, collection: %w[Offer Inquiry]
      f.input :title
      f.input :user
      f.input :category
      f.input :description
      f.input :tag_list
    end
    f.actions
  end

  permit_params :type, :tag_list, *Post.attribute_names

  filter :type, as: :select, collection: -> { Post.subclasses }
  filter :title
  filter :user
  filter :organization
  filter :category
  filter :created_at
end
