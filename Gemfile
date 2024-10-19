source 'https://rubygems.org'

gem 'rails', '~> 7.0.8'
gem 'rails-i18n', '~> 7.0'
gem 'puma', '~> 6.4'
gem 'rdiscount', '~> 2.2.7'
gem 'rubyzip', '~> 2.3.0'
gem 'activeadmin', '~> 2.14'
gem 'bootsnap', '~> 1.12', require: false
gem 'has_scope', '~> 0.7.2'
gem 'pundit', '~> 2.1.0'
gem 'pg', '~> 1.4'
gem 'json_translate', '~> 4.0.0'
gem 'devise', '~> 4.9.1'
gem 'devise-i18n', '~> 1.11.0'
gem 'invisible_captcha', '~> 2.3.0'
gem 'http_accept_language', '~> 2.1.1'
gem 'kaminari', '~> 1.2.1'
gem 'simple_form', '~> 5.0.2'
gem 'prawn', '~> 2.5.0'
gem 'prawn-table', '~> 0.2.2'
gem 'pg_search', '~> 2.3.5'
gem 'sidekiq', '~> 6.5'
gem 'sidekiq-cron', '~> 1.12.0'
gem 'aws-sdk-s3', '~> 1.94', require: false
gem 'image_processing', '~> 1.12'
gem 'active_storage_validations', '~> 1.1.3'

# Assets
gem 'jquery-rails', '~> 4.4.0'
gem 'bootstrap-sass', '~> 3.4'
gem 'sassc-rails', '~> 2.1.2'
gem 'select2-rails', '~> 4.0.13'

group :production do
  # we are using an ExecJS runtime only on the precompilation phase
  gem "uglifier", "~> 4.2.0", require: false
end

group :development do
  gem 'localeapp', '~> 3.3', require: false
  gem 'letter_opener', '~> 1.7.0'
  gem 'web-console', '~> 4.1.0'
end

group :development, :test do
  gem 'byebug', '~> 11.0'
  gem 'rubocop', '~> 1.6', require: false
  gem 'rubocop-rails', '~> 2.9', require: false
  gem 'dotenv-rails', '~> 2.7.1'
end

group :test do
  gem 'rspec-rails', '~> 6.0'
  gem 'rails-controller-testing'
  gem 'database_cleaner', '~> 2.0'
  gem 'shoulda-matchers', '~> 4.4'
  gem 'fabrication', '~> 2.20'
  gem 'faker', '~> 2.15'
  gem 'capybara', '~> 3.29'
  gem 'selenium-webdriver', '~> 4.16'
  gem 'simplecov', '~> 0.22', require: false
end
