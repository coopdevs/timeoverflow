source 'https://rubygems.org'

# Force ruby version to 2.0.0
ruby '2.0.0'

gem 'rails', '~> 4.1'
gem 'rails-i18n', '~> 4.0.2'
gem 'rails_12factor', '~> 0.0.2'
gem "rdiscount", '~> 2.1.7'

gem 'high_voltage', '~> 2.1.0'

gem 'activeadmin', '1.0.0.pre', github: 'gregbell/active_admin'

gem 'has_scope', '0.6.0.rc'
gem 'inherited_resources', '~> 1.3'
gem 'pundit', '~> 0.2.1'

gem 'pg','~> 0.17.0'
gem 'hstore_translate', '~> 0.0.12'

gem 'dalli', '~> 2.6.4'

# Note: on 29-Sept-14 requested repository only had 5.0.0.beta1 available
# if required is 4.0.1 rubygems.org should be ok to be used...
gem 'sass-rails','4.0.1' #github: 'rails/sass-rails'

# gem 'compass-rails'
gem 'coffee-rails', '~> 4.0.1'
gem 'ngannotate-rails', '~> 0.9.2'
gem 'uglifier', '>= 1.0.3'

gem 'jquery-rails','~> 3.1.0'

gem 'devise', '3.2.4'
gem "devise_browserid_authenticatable", '~> 1.3.2'

gem 'thin'
gem 'foreman','~> 0.63.0'
gem 'dotenv-rails', '~> 0.9.0'

gem 'kaminari', '~> 0.15'
gem 'textacular', "~> 3.0", require: 'textacular/rails'

# To use debugger
# gem 'debugger'

gem "haml-rails", '~> 0.5.3'
gem 'turbolinks', '~> 1.3.0'

gem "simple_form", ">= 3.0.0"

gem "awesome_print", '~> 1.2.0'
gem "jbuilder", '~> 1.5.1'
gem "paranoia", '~> 2.0.0'

gem "rest-client", '~> 1.6.7'

gem 'memcachier', '~> 0.0.2'
gem 'rollbar', '~> 0.12.18'

gem "rails-erd", '~> 1.1.0', group: :development

gem 'travis-lint', '~> 1.7.0'

gem 'faker', '~> 1.2.0'
gem 'fabrication', '~> 2.9.1'

gem "shelly-dependencies", '~> 0.2.3'

group :development do
  gem "binding_of_caller", '~> 0.7.2'
  gem "better_errors", '~> 1.0.1'
end

group :development, :test do
  gem "rspec-rails", '~> 3.1.0'
end

group :test do
  # Needed for TravisCI
  gem 'rake', '~> 10.3.2'
  gem "database_cleaner", '~> 1.2.0'
end
