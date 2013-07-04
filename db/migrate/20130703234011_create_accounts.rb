class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :accountable, polymorphic: true, index: true
      t.integer :balance, default: 0
      t.integer :max_allowed_balance
      t.integer :min_allowed_balance
      t.boolean :flagged

      t.timestamps
    end
  end
end
