class PushNotification < ActiveRecord::Base
  belongs_to :event, foreign_key: 'event_id'
  belongs_to :device_token, foreign_key: 'device_token_id'

  validates :event, :device_token, presence: true
  validates :title, :body, presence: true, allow_blank: false

  delegate :token, to: :device_token
end
