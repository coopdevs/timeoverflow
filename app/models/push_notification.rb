class PushNotification < ActiveRecord::Base
  belongs_to :event, foreign_key: 'event_id'
  belongs_to :device_token, foreign_key: 'device_token_id'

  validates :event, :device_token, :title, presence: true

  def to
    device_token.token
  end
end
