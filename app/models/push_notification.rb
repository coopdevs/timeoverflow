class PushNotification < ApplicationRecord
  belongs_to :event
  belongs_to :device_token

  validates :title, :body, presence: true, allow_blank: false

  delegate :token, to: :device_token
end
