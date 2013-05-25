class CreateMovements < ActiveRecord::Migration
  def change
    create_table :movements do |t|
      t.references :user
      t.references :transfer
      t.string :type

      t.timestamps
    end
    add_index :movements, :user_id
    add_index :movements, :transfer_id
  end
end
