# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Organization.find_or_create_by(id: 1) do |org|
  org.name = "TimeOverflow"
end

User.find_or_create_by(email: "saverio.trioni@gmail.com") do |user|
  user.username = "admin"
  user.organization_id = 1
  user.admin = true
  user.superadmin = true
  user.gender = "male"
  user.identity_document = "X0000000X"
end

%w(
    accompainment
    health
    domestic
    administrative tasks
    learning
    leisure
    consulting
    other
  ).each do |name|
  Category.find_or_create_by(name: name)
end
