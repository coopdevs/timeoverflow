class Petition < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  STATUS = {
    0 => 'pending',
    1 => 'accepted',
    2 => 'declined'
  }
end
