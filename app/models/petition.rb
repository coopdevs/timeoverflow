class Petition < ApplicationRecord
  enum status: %i[pending accepted declined]

  belongs_to :user
  belongs_to :organization
end
