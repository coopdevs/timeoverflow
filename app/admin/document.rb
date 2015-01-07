ActiveAdmin.register Document do
  permit_params *Document.attribute_names

  index do
    selectable_column
    id_column
    column :documentable
    column :label
    column :title
    actions
  end

  show do |t|
    attributes_table do
      row :id
      row :documentable do
        t.documentable
      end
      row :label
      row :title
      row :content do
        raw RDiscount.new(t.content).to_html
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :label
      f.input :title, as: :string
      f.input :content
    end
    f.actions
  end
end
