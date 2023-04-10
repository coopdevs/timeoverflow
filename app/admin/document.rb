ActiveAdmin.register Document do
  permit_params :label, :title, :content

  index do
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
      row :title_translations do
        render_translations(t.title_translations)
      end
      row :content_translations do
        render_translations(t.content_translations, "<hr>")
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :label
      f.input :title, as: :text
      f.input :content, as: :text
    end
    f.actions
  end
end
