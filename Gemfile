source 'https://rubygems.org'
ruby '2.3.1'

gem 'rails', '4.2.5.2'
gem 'rails-i18n'
gem 'rails_12factor'
gem "rdiscount"
gem 'high_voltage', '~> 2.1.0'
gem 'activeadmin', github: 'activeadmin'
gem 'has_scope'
gem 'pundit'
gem 'pg', '0.17.1'
gem 'hstore_translate'
gem 'dalli'
gem 'devise', '3.5.6'
gem "http_accept_language"
gem 'thin'
gem 'unicorn'
gem 'foreman'
gem 'dotenv-rails'
gem 'kaminari'
gem "simple_form", ">= 3.0.0"
gem "awesome_print"
gem 'memcachier'
gem 'rollbar', '2.8.3'
gem 'travis-lint'
gem 'whenever', :require => false
gem 'prawn'
gem 'prawn-table'
gem 'bundler', '>= 1.10.6'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

# Assets
gem 'jquery-rails', '4.0.4'
gem 'jquery-ui-rails'
gem 'bootstrap-sass'
gem 'sass-rails', '~> 5.0.1'
gem 'coffee-rails'
gem 'uglifier', '2.7.2'
gem 'select2-rails'

# Security
gem 'nokogiri', '1.6.7.2'

group :development do
  gem "binding_of_caller"
  gem "better_errors"
  gem "rubocop"
  gem 'web-console', '2.1.3'
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-rails', '~> 1.1'
  # gem 'capistrano3-delayed-job', '~> 1.0'
  gem 'airbrussh', require: false
  gem "quiet_assets"
end

group :development, :test do
  gem "rspec-rails", '~> 3.4.0'
  gem "capybara", '~> 2.4.4'
  gem "byebug"
end

group :test do
  # Needed for TravisCI
  gem 'rake'

  # Do not upgrade until
  # https://github.com/DatabaseCleaner/database_cleaner/issues/317 is fixed
  gem "database_cleaner", '1.3.0'

  gem 'shoulda', ">= 3.5"
  gem 'fabrication'
  gem 'faker'
end
