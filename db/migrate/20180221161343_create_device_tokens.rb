class CreateDeviceTokens < ActiveRecord::Migration
  def change
    create_table :device_tokens do |t|
      t.integer :user_id, null: false
      t.string :token, null: false

      t.timestamps
    end
    add_index :device_tokens, %i[user_id token], unique: true
  end
end
