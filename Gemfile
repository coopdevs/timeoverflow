source 'https://rubygems.org'

ruby File.read('.ruby-version').strip

gem 'rails', '~> 4.2'
gem 'rails-i18n'
gem "rdiscount"
gem 'activeadmin', '~> 1.2.1'
gem 'has_scope'
gem 'pundit', '~> 2.0.0'
gem 'pg', '0.21.0'
gem 'hstore_translate'
gem 'devise', '~> 4.5.0'
gem "http_accept_language", '~> 2.1.1'
gem 'unicorn'
gem 'kaminari', '~> 1.1.1'
gem "simple_form", ">= 3.0.0"
gem 'rollbar', '2.8.3'
gem 'prawn', '~> 2.2.0'
gem 'prawn-table', '~> 0.2.2'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
gem 'skylight'
gem 'sidekiq', '5.1.3'
gem 'sidekiq-cron', '~> 1.1.0'

# Assets
gem 'jquery-rails', '>= 4.2.0'
gem 'bootstrap-sass'
gem 'sass-rails', '~> 5.0.7'
gem 'coffee-rails'
gem 'uglifier', '2.7.2'
gem 'select2-rails'

group :development do
  gem "binding_of_caller", '~> 0.8.0'
  gem "better_errors", '~> 2.4.0'
  gem 'rubocop', '~> 0.65.0', require: false
  gem 'web-console', '2.1.3'
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rbenv', '~> 2.1'
  gem 'airbrussh', require: false
  gem 'localeapp', '2.1.1', require: false
  gem 'letter_opener', '1.4.1'
  gem 'dotenv-rails', '~> 2.7.1'
end

group :development, :test do
  gem "byebug", '~> 11.0'
end

group :test do
  gem "rspec-rails", '~> 3.8.2'
  gem "database_cleaner", '1.6.2'
  gem 'shoulda-matchers', '~> 3.1.2'
  gem 'fabrication', '~> 2.20'
  gem 'faker', '~> 1.9'
  gem 'capybara', '~> 3.15'
  gem 'selenium-webdriver', '~> 3.142'
  gem 'webdrivers', '~> 4.1.2'
  gem 'simplecov', '~> 0.17', require: false
end
