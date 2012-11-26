# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.find_or_create_by_email("admin@example.com") do |u|
  u.username = "admin"
  u.email = "admin@example.com"
  u.password = "password"
end


categories = YAML.load_file(File.dirname(__FILE__) + "/seeds/categories.yml")["categories"]

ap categories

def load_categories(list_or_hash, parent)
  if list_or_hash.is_a? Hash
    list_or_hash.each do |k, v|
      c = Category.find_or_create_by_name k
      c.parent = parent
      c.save
      load_categories(v, c)
    end
  else
    list_or_hash.each do |k|
      c = Category.find_or_create_by_name k
      c.parent = parent
      c.save
    end
  end
end

load_categories(categories, nil)

# categories.each do |c|
#   Category.find_or_create_by_name c
# end
