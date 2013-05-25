# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first  

admin = User.find_or_create_by_email("admin@example.com") do |u|
  u.username = "admin"
  u.email = "admin@example.com"
  u.password = "password"
  u.superadmin = u.admin = true
  organization_id = 1
end

