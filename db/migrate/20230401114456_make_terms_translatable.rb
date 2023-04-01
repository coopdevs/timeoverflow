class MakeTermsTranslatable < ActiveRecord::Migration[6.1]
  def up
    rename_column :documents, :title, :title_translations
    rename_column :documents, :content, :content_translations
    change_column :documents, :title_translations, :jsonb, default: {}, null: false, using: 'title_translations::jsonb'
    change_column :documents, :content_translations, :jsonb, default: {}, null: false, using: 'content_translations::jsonb'
  end

  def down
    rename_column :documents, :title_translations, :title
    rename_column :documents, :content_translations, :content
    change_column :documents, :title, :text, default: nil, null: true, using: 'title::text'
    change_column :documents, :content, :text, default: nil, null: true, using: 'content::text'
  end
end
