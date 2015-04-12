Fabricator(:post) do

  title { Faker::Lorem.sentence }
  user { Fabricate(:user) }
  description { Faker::Lorem.paragraph }
  category { Fabricate(:category) }
  permanent { false }
  joinable { false }
  global { false }
  active { true }

end

Fabricator(:inquiry) do

  type "Inquiry"

  title { Faker::Lorem.sentence }
  user { Fabricate(:user) }
  description { Faker::Lorem.paragraph }
  category { Fabricate(:category) }
  permanent { false }
  joinable { false }
  global { false }
  active { true }

end

Fabricator(:offer) do

  type "Offer"

  title { Faker::Lorem.sentence }
  user { Fabricate(:user) }
  description { Faker::Lorem.paragraph }
  category { Fabricate(:category) }
  permanent { false }
  joinable { false }
  global { false }
  active { true }

end
