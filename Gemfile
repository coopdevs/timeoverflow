source 'https://rubygems.org'

ruby File.read('.ruby-version').strip

gem 'rails', '~> 6.0.0'
gem 'rails-i18n', '~> 6.0.0'
gem 'rdiscount', '~> 2.2.0.1'
gem 'activeadmin', '~> 2.3.1'
gem 'has_scope', '~> 0.7.2'
gem 'pundit', '~> 2.0.0'
gem 'pg', '1.1.4'
gem 'json_translate', '~> 4.0.0'
gem 'dalli'
gem 'devise', '~> 4.7.1'
gem "http_accept_language", '~> 2.1.1'
gem 'unicorn', '~> 5.5.1'
gem 'kaminari', '~> 1.1.1'
gem 'simple_form', '~> 4.1.0'
gem 'rollbar', '~> 2.22.1'
gem 'whenever', require: false
gem 'prawn', '~> 2.2.0'
gem 'prawn-table', '~> 0.2.2'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
gem 'skylight', '~> 4.1.2'
gem 'sidekiq', '5.1.3'
gem 'sidekiq-cron', '0.6.3'
# TODO: remove this once the following issue has been addressed
#       https://github.com/ondrejbartas/sidekiq-cron/issues/199
gem 'rufus-scheduler', '~> 3.4.2'

# Assets
gem 'jquery-rails', '~> 4.3.5'
gem 'bootstrap-sass'
gem 'sassc-rails', '~> 2.1.2'
gem 'uglifier', '2.7.2'
gem 'select2-rails'

group :development do
  gem 'listen'
  gem 'rubocop', '~> 0.52.1', require: false
  gem 'web-console', '4.0.1'
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rbenv', '~> 2.1'
  gem 'airbrussh', require: false
  gem 'localeapp', '2.1.1', require: false
  gem 'letter_opener', '1.4.1'
  gem 'dotenv-rails', '~> 2.7.1'
end

group :development, :test do
  gem 'byebug', '~> 11.0'
end

group :test do
  gem 'rspec-rails', '~> 4.0.0.beta2'
  gem 'rails-controller-testing'
  gem "database_cleaner", '1.6.2'
  gem 'shoulda-matchers', '~> 4.1.2'
  gem 'fabrication'
  gem 'faker', '~> 1.9'
  gem 'capybara', '~> 3.15'
  gem 'selenium-webdriver', '~> 3.142'
  gem 'webdrivers', '~> 4.1.2'
  gem 'simplecov', '~> 0.17', require: false
end
