class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.references :post, index: true
      t.text :reason
      t.references :operator, index: true

      t.timestamps
    end
  end
end
