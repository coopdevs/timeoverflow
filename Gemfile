source "https://rubygems.org"

gem "activeadmin", "~> 2.14"
gem "active_storage_validations", "~> 1.1.3"
gem "aws-sdk-s3", "~> 1.94", require: false
gem "bootsnap", "~> 1.12.0", require: false
gem "devise", "~> 4.9.1"
gem "devise-i18n", "~> 1.11.0"
gem "has_scope", "~> 0.7.2"
gem "http_accept_language", "~> 2.1.1"
gem "image_processing", "~> 1.12"
gem "json_translate", "~> 4.0.0"
gem "kaminari", "~> 1.2.1"
gem "pg", "~> 1.4"
gem "pg_search", "~> 2.3.5"
gem "prawn", "~> 2.4.0"
gem "prawn-table", "~> 0.2.2"
gem "puma", ">= 5.0.0"
gem "pundit", "~> 2.1.0"
gem "rails", "~> 6.1.1"
gem "rails-i18n", "~> 7.0"
gem "rdiscount", "~> 2.2.7"
gem "rollbar", "~> 2.22.1"
gem "rubyzip", "~> 2.3.0"
gem "sidekiq", "~> 6.5"
gem "sidekiq-cron", "~> 1.9.1"
gem "simple_form", "~> 5.0.2"
gem "skylight", "~> 5.0"

# Assets
gem "bootstrap-sass", "~> 3.4"
gem "jquery-rails", "~> 4.4.0"
gem "sassc-rails", "~> 2.1.2"
gem "select2-rails", "~> 4.0.13"

group :production do
  # we are using an ExecJS runtime only on the precompilation phase
  gem "uglifier", "~> 4.2.0", require: false
end

group :development do
  gem "letter_opener", "~> 1.7.0"
  gem "listen", "~> 3.2.0"
  gem "localeapp", "~> 3.3", require: false
  gem "uglifier", "~> 4.2.0"
  gem "web-console", "~> 4.1.0"
end

group :development, :test do
  gem "byebug", "~> 11.0"
  gem "dotenv-rails", "~> 2.7.1"
  gem "rubocop", "~> 1.6", require: false
  gem "rubocop-rails", "~> 2.9", require: false
end

group :test do
  gem "capybara", "~> 3.29"
  gem "database_cleaner", "~> 1.8.5"
  gem "fabrication", "~> 2.20"
  gem "faker", "~> 2.15"
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 4.0.0"
  gem "selenium-webdriver", "~> 4.1.0"
  gem "shoulda-matchers", "~> 4.4"
  gem "simplecov", "~> 0.22", require: false
  gem "webdrivers", "~> 5.3"
end
