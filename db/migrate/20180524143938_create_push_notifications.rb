class CreatePushNotifications < ActiveRecord::Migration
  def change
    create_table :push_notifications do |t|
      t.references :event, null: false
      t.references :device_token, null: false
      t.datetime   :processed_at

      t.timestamps null: false
    end

    add_foreign_key :push_notifications, :events
    add_foreign_key :push_notifications, :device_tokens
  end
end
