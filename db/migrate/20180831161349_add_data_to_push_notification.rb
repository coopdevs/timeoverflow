class AddDataToPushNotification < ActiveRecord::Migration
  def up
    add_column :push_notifications, :data, :json, null: false, default: "{}"
  end

  def down
    remove_column :push_notifications, :data
  end
end
