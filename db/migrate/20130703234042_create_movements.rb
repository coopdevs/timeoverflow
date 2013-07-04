class CreateMovements < ActiveRecord::Migration
  def change
    create_table :movements do |t|
      t.references :account, index: true
      t.references :transfer, index: true
      t.integer :amount

      t.timestamps
    end
  end
end
