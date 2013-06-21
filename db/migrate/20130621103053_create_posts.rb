class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :type
      t.references :category
      t.references :user
      t.text :description
      t.date :start_on
      t.date :end_on
      t.boolean :permanent
      t.boolean :joinable
      t.boolean :global

      t.timestamps
    end
    add_index :posts, :category_id
    add_index :posts, :user_id
  end
end
