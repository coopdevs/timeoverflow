class MigrateHstoreToJson < ActiveRecord::Migration[6.1]
  def up
    rename_column :categories, :name_translations, :name_translations_hstore
    add_column    :categories, :name_translations, :jsonb, default: {}, null: false, index: { using: 'gin' }
    execute       'UPDATE "categories" SET "name_translations" = json_object(hstore_to_matrix("name_translations_hstore"))::jsonb'
    remove_column :categories, :name_translations_hstore
  end

  def down
    rename_column :categories, :name_translations, :name_translations_jsonb
    add_column    :categories, :name_translations, :hstore, default: {}, null: false
    execute       'UPDATE "categories" SET "name_translations" = (SELECT hstore(key, value) FROM jsonb_each_text("name_translations_jsonb"))'
    remove_column :categories, :name_translations_jsonb
  end
end
