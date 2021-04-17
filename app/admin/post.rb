ActiveAdmin.register Post do
  index do
    id_column
    column :class
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
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :type, as: :select, collection: %w[Offer Inquiry]
      f.input :title
      f.input :organization
      f.input :user, hint: "* should be member of the selected organization"
      f.input :category
      f.input :description
      f.input :tag_list
      f.input :active
    end
    f.actions
  end

  permit_params :type, :tag_list, *Post.attribute_names

  filter :type, as: :select, collection: -> { Post.subclasses }
  filter :id
  filter :title
  filter :organization
  filter :user
  filter :category
  filter :active
  filter :created_at
end
