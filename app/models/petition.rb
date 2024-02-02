class Petition < ApplicationRecord
  enum status: { pending: 0, accepted: 1, declined: 2 }

  belongs_to :user
  belongs_to :organization
end
