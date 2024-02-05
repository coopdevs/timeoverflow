ENV["RAILS_ENV"] ||= 'test'
ENV["ADMINS"] = "admin@timeoverflow.org"

require 'simplecov'

SimpleCov.formatter = if ENV["CI"]
  require "simplecov_json_formatter"
  SimpleCov::Formatter::JSONFormatter
else
  SimpleCov::Formatter::HTMLFormatter
end
SimpleCov.start 'rails'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'database_cleaner'
require 'fabrication'
require 'selenium/webdriver'
require 'faker'
require 'shoulda/matchers'

Capybara.server = :puma
Capybara.register_driver :headless_chrome do |app|
  browser_options = Selenium::WebDriver::Chrome::Options.new(
    args: %w(headless disable-gpu no-sandbox)
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: browser_options
  )
end
Capybara.default_driver = :headless_chrome
Capybara.javascript_driver = Capybara.default_driver

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Make sure schema persists when running tests.
# We ran into an error that forced us to run rake db:migrate RAILS_ENV=test
# before running tests. This kind of fixes it, although we should have a closer
# look at this and find a better solution
# Ref:
# https://www.relishapp.com/rspec/rspec-rails/docs/upgrade#pending-migration-checks
ActiveRecord::Migration.maintain_test_schema!

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Disable global namespace monkey patching.
  config.expose_dsl_globally = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  puts "Randomized with seed #{config.seed}."

  config.register_ordering(:global) do |items|
    items_by_type = items.group_by { |item| item.metadata[:type] === :feature ? :feature : :rest }

    feature_specs = items_by_type[:feature] || []
    rest_of_specs = items_by_type[:rest] || []

    random = Random.new(config.seed)

    [
      *rest_of_specs.shuffle(random: random),
      *feature_specs.shuffle(random: random)
    ]
  end

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include ControllerMacros, type: :controller
  config.include Features::SessionHelpers, type: :feature

  # Create terms and conditions
  config.before do
    Document.create!(label: "t&c") do |doc|
      doc.title = "Terms and Conditions"
      doc.content = "blah blah blah"
    end
  end

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    # :rack_test driver's Rack app under test shares database connection
    # with the specs, so continue to use transaction strategy for speed.
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    unless driver_shares_db_connection_with_specs
      # Driver is probably for an external browser with an app
      # under test that does *not* share a database connection with the
      # specs, so use truncation strategy.
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  config.before(:each, type: :feature) do
    I18n.locale = I18n.default_locale
  end

  # Controllers must render the content of the view
  config.render_views
end

RSpec.configure(&:infer_spec_type_from_file_location!)

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
