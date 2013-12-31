# encoding: utf-8

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
  user.confirmed_at = DateTime.now.utc
  user.username = "admin"
  user.gender = "male"
  user.identity_document = "X0000000X"
end

User.find_by(email: "saverio.trioni@gmail.com").members.find_or_create_by(organization_id: 1) do |member|
  member.manager = true
  member.entry_date = DateTime.now.utc
end

unless Category.exists?
  Category.connection.execute "ALTER SEQUENCE categories_id_seq RESTART;"
  [
    "Acompañamiento", "Salud", "Domestic", "administrative tasks", "Clases", "Ocio", "consulting", "Otro"
  ].each do |name|
    unless Category.with_name_translation(name).exists?
      Category.create { |c| c.name = name }
    end
  end
end


Document.find_or_create_by(label: "t&c") do |doc|
  doc.title = "Terms and Conditions"
  doc.content = "blah blah blah"
end
