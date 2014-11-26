class CreateCategoriesUsers < ActiveRecord::Migration
  def change
    create_table :categories_users do |t|
      t.references :category
      t.references :user
    end
    add_index :categories_users, :category_id
    add_index :categories_users, :user_id
  end
end
