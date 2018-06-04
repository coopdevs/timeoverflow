class AddTitleToPushNotification < ActiveRecord::Migration
  def up
    add_column :push_notifications, :title, :string, null: false, default: 'Title for existing records'
    change_column_default(:push_notifications, :title, nil)
  end

  def down
    remove_column :push_notifications, :title
  end
end
