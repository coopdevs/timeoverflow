class DeviceToken < ApplicationRecord
  belongs_to :user

  validates :token, presence: true
  validates :token, uniqueness: { scope: :user_id }
end
