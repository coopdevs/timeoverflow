Fabricator(:member) do

  user { Fabricate(:user) }
  organization { Fabricate(:organization) }
  manager false
  active true

end

Fabricator(:admin, from: :member) do

  manager true

end
