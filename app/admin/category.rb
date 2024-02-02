ActiveAdmin.register Category do
  index do
    id_column
    column :name do |category|
      "#{category_icon(category)} #{category.name}".html_safe
    end
    actions
  end

  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :icon_name,
              hint: "See all available <a href='https://getbootstrap.com/docs/3.3/components/#glyphicons' target='_blank'>icons here</a>".html_safe
    end
    f.actions
  end

  show do |cat|
    attributes_table do
      row :name do
        "#{category_icon(cat)} #{cat.name}".html_safe
      end
      row :icon_name
      row :created_at
      row :updated_at
      row :name_translations do
        render_translations(cat.name_translations)
      end
    end
  end

  permit_params :name, :icon_name
end
