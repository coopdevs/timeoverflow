ActiveAdmin.register Document do
  permit_params *Document.attribute_names, :title, :content

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
        t.title_translations.map do |locale, translation|
          tag.strong("#{I18n.t("locales.#{locale}", locale: locale)}: ") +
          tag.span(translation)
        end.join(" | ").html_safe
      end
      row :content_translations do
        t.content_translations.map do |locale, translation|
          tag.strong("#{I18n.t("locales.#{locale}", locale: locale)}: ") +
          tag.span(raw RDiscount.new(translation).to_html)
        end.join("\n").html_safe
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
