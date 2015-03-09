Fabricator(:user) do
  Faker::Config.locale = :es

  username { Faker::Internet.user_name }
  email { Faker::Internet.email }
  date_of_birth { DateTime.now.utc }
  identity_document { sequence(:identity_document, 1) { |n| "X000000#{n}X" } }
  phone { Faker::PhoneNumber.phone_number }
  alt_phone { Faker::PhoneNumber.cell_phone }
  address { Faker::Address.street_address + " " + Faker::Address.zip_code + " " + Faker::Address.city + " (" + Faker::Address.state + ")"}
  gender { ["male", "female"].shuffle.first }
  description { Faker::Lorem.paragraph }

  terms_accepted_at DateTime.now.utc
  confirmed_at DateTime.now.utc
end
