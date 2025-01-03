class Petition < ApplicationRecord
  enum status: %i[pending accepted declined]

  belongs_to :user
  belongs_to :organization

  validates :user_id, uniqueness: { scope: :organization_id }
end
