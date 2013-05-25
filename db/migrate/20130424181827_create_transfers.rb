class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.references :user
      t.references :movement
      t.references :movement
      t.float :amount
      t.references :category
      t.date :date

      t.timestamps
    end
  end
end
