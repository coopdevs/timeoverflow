class AddPushNotificationsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :push_notifications, :boolean, default: true, null: false
  end
end
