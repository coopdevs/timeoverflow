ActiveAdmin.register Category do
  index do
    id_column
    column :name do |category|
      "#{tag.span(nil, class: "glyphicon glyphicon-#{category.icon_name}")} #{category.name}".html_safe
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :icon_name, hint: "See all available <a href='https://getbootstrap.com/docs/3.3/components/#glyphicons' target='_blank'>icons here</a>".html_safe
    end
    f.actions
  end

  show do |cat|
    attributes_table do
      row :created_at
      row :updated_at
      row :icon_name
      row :name_translations do
        render_translations(cat.name_translations, " | ")
      end
    end
  end

  permit_params :name, :icon_name
end
