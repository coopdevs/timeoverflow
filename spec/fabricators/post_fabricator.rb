Fabricator(:post) do

  title { Faker::Lorem.sentence }
  user { Fabricate(:user) }
  description { Faker::Lorem.paragraph }
  permanent { false }
  joinable { false }
  global { false }

end

Fabricator(:inquiry) do

  type "Inquiry"

  title { Faker::Lorem.sentence }
  user { Fabricate(:user) }
  description { Faker::Lorem.paragraph }
  permanent { false }
  joinable { false }
  global { false }

end

Fabricator(:offer) do

  type "Offer"

  title { Faker::Lorem.sentence }
  user { Fabricate(:user) }
  description { Faker::Lorem.paragraph }
  permanent { false }
  joinable { false }
  global { false }

end