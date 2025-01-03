class Petition < ApplicationRecord
  DEFAULT_STATUS = "pending"

  enum status: %i[pending accepted declined], _default: DEFAULT_STATUS

  belongs_to :user
  belongs_to :organization

  validates :user_id, uniqueness: { scope: :organization_id }
end
