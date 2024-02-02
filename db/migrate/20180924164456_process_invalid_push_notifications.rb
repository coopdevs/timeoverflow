class ProcessInvalidPushNotifications < ActiveRecord::Migration
  def up
    PushNotification.where(processed_at: nil).find_in_batches do |batch|
      batch.each do |push_notification|
        unless push_notification.valid?
          now = Time.now.utc
          push_notification.update_columns(processed_at: now, updated_at: now)
          puts "Updating invalid PushNotification ##{push_notification.id}"
        end
      end
    end
  end

  def down
    puts "no."
  end
end
