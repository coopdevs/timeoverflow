ActiveAdmin.register Category do
  index do
    id_column
    column :name, sortable: false
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end

  show do |cat|
    attributes_table do
      row :created_at
      row :updated_at
      row :name_translations do
        cat.name_translations.map do |locale, translation|
          tag.strong("#{I18n.t("locales.#{locale}", locale: locale)}: ") +
          tag.span(translation)
        end.join(" | ").html_safe
      end
    end
  end

  permit_params :name
end
