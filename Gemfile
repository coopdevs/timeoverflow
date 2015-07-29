source 'https://rubygems.org'
ruby '2.2.2'

gem 'rails', '~> 4.2'
gem 'rails-i18n'
gem 'rails_12factor'
gem "rdiscount"
gem 'high_voltage', '~> 2.1.0'
gem 'activeadmin', github: 'activeadmin'
gem 'has_scope'
gem 'responders', '~> 2.0'
gem 'pundit'
gem 'pg', '0.17.1'
gem 'hstore_translate'
gem 'dalli'
gem "sass-rails", "4.0.5"
gem 'coffee-rails'
gem 'slim-rails' # much better than haml
gem 'ngannotate-rails'
gem 'uglifier', '>= 1.0.3'
gem 'jquery-rails'
gem "devise"
gem "http_accept_language"
gem 'thin'
gem 'foreman'
gem 'dotenv-rails'
gem 'kaminari'
gem "haml-rails"
gem 'turbolinks'
gem "simple_form", ">= 3.0.0"
gem "awesome_print"
gem "jbuilder"
gem "paranoia"
gem "rest-client"
gem 'memcachier'
gem 'rollbar'
gem 'travis-lint'
gem "shelly-dependencies"
gem 'whenever', :require => false
gem 'prawn'
gem 'prawn-table'

# Integrate an external search engine - tags + full-text in PG are not really the best
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

group :development do
  gem "binding_of_caller"
  gem "better_errors"
  gem "rubocop"
  gem "haml-lint"
  gem 'web-console', '~> 2.0'
  gem "rails-erd"
end

group :development, :test do
  gem "rspec-rails", '~> 2.14'
  gem "capybara", '~> 2.4.4'
  gem "byebug"
end

group :test do
  # Needed for TravisCI
  gem 'rake'
  gem "database_cleaner"
  gem 'shoulda', ">= 3.5"
  gem 'fabrication'
  gem 'faker'
end
