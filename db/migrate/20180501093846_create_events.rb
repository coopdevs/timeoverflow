class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :action, :null => false

      t.integer :post_id
      t.integer :member_id
      t.integer :transfer_id

      t.timestamps
    end
  end
end
