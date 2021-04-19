ActiveAdmin.register Post do
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
    f.semantic_errors *f.object.errors.keys
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

  permit_params :type, :tag_list, *Post.attribute_names

  filter :type, as: :select, collection: -> { Post.subclasses }
  filter :id
  filter :title
  filter :organization
  filter :user
  filter :category
  filter :is_group
  filter :active
  filter :created_at
end
