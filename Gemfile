source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '~> 4.2'
gem 'rails-i18n'
gem "rdiscount"
gem 'activeadmin', '~> 1.2.1'
gem 'has_scope'
gem 'pundit'
gem 'pg', '0.17.1'
gem 'hstore_translate'
gem 'dalli'
gem 'devise', '~> 4.4.1'
gem "http_accept_language", '~> 2.1.1'
gem 'unicorn'
gem 'kaminari', '~> 1.1.1'
gem "simple_form", ">= 3.0.0"
gem 'rollbar', '2.8.3'
gem 'whenever', require: false
gem 'prawn', '~> 2.2.0'
gem 'prawn-table', '~> 0.2.2'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
gem 'skylight'

# Assets
gem 'jquery-rails', '>= 4.2.0'
gem 'jquery-ui-rails'
gem 'bootstrap-sass'
gem 'sass-rails', '~> 5.0.7'
gem 'coffee-rails'
gem 'uglifier', '2.7.2'
gem 'select2-rails'

group :development do
  gem "binding_of_caller", '~> 0.8.0'
  gem "better_errors", '~> 2.4.0'
  gem 'rubocop', '~> 0.52.1', require: false
  gem 'web-console', '2.1.3'
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rbenv', '~> 2.1'
  gem 'airbrussh', require: false
  gem 'localeapp', '2.1.1', require: false
  gem 'letter_opener', '1.4.1'
  gem 'dotenv-rails', '1.0.2'
end

group :development, :test do
  gem "rspec-rails", '~> 3.7.2'
  gem "byebug"
end

group :test do
  gem "database_cleaner", '1.6.2'
  gem 'shoulda', ">= 3.5"
  gem 'fabrication'
  gem 'faker'
  gem 'capybara', '~> 2.7'
  gem 'capybara-selenium', '~> 0.0.6'
  gem 'chromedriver-helper', '~> 1.0'
end

group :production do
  gem 'rails_12factor', '0.0.3'
end
