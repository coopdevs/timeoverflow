Fabricator(:member) do

  user { Fabricate(:user) }
  organization { Fabricate(:organization) }
  manager false
  active true

end
