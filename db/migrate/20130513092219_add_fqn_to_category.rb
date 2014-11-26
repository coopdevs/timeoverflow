class AddFqnToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :fqn_translations, :hstore
  end
end
