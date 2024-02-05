Fabricator(:user) do
  username { Faker::Internet.user_name }
  email { Faker::Internet.email }
  date_of_birth { DateTime.now.utc }
  phone { Faker::PhoneNumber.phone_number }
  alt_phone { Faker::PhoneNumber.cell_phone }
  address { Faker::Address.street_address + " " + Faker::Address.zip_code + " " + Faker::Address.city + " (" + Faker::Address.state + ")"}
  gender { ["male", "female"].shuffle.first }
  description { Faker::Lorem.paragraph }
  last_sign_in_at { DateTime.new(2018, 10, 1) }
  terms_accepted_at DateTime.now.utc
  confirmed_at DateTime.now.utc
  locale I18n.default_locale
end
