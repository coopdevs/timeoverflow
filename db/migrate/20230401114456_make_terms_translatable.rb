class MakeTermsTranslatable < ActiveRecord::Migration[6.1]
  def up
    add_column :documents, :title_translations, :jsonb, default: {}, null: false
    add_column :documents, :content_translations, :jsonb, default: {}, null: false
    Document.find_each do |doc|
      doc.update_columns(title_translations: { es: doc[:title] }.to_json, content_translations: { es: doc[:content] }.to_json)
    end
    remove_column :documents, :title
    remove_column :documents, :content
  end

  def down
    add_column :documents, :title, :text
    add_column :documents, :content, :text
    Document.find_each do |doc|
      doc.update_columns(title: doc.title_translations["es"], content: doc.content_translations["es"])
    end
    remove_column :documents, :title_translations
    remove_column :documents, :content_translations
  end
end
