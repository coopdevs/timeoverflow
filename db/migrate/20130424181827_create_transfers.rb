class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.references :user
      t.float :amount
      t.references :category
      t.date :date

      t.timestamps
    end
  end
end
