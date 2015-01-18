ActiveAdmin.register Category do
  index do
    selectable_column
    id_column
    column :name, sortable: false
    actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :name
    end
    f.actions
  end

  show(title: :name) do |cat|
    attributes_table do
      row :created_at
      row :updated_at
      row :name_translations do
        cat.disable_fallback
        content_tag :div do
          I18n.available_locales.map do |loc|
            next unless cat.send("name_#{loc}")
            content_tag(:strong, "#{loc}: ") +
              content_tag(:span, cat.send("name_#{loc}"))
          end.compact.sum
        end
      end
    end
    active_admin_comments
  end

  permit_params :name
end
