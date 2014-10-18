class AddNameTranslationsToCategory < ActiveRecord::Migration
  def up
    add_column :categories, :name_translations, :hstore
    remove_column :categories, :name
  end
  def down
    remove_column :categories, :name_translations, :hstore
    add_column :categories, :name
  end
end
