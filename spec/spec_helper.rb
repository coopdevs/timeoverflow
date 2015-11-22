# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
ENV["ADMINS"] = "superadmin@example.com"

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Make sure schem persists when running tests.
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
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.include Devise::TestHelpers, :type => :controller
  config.include ControllerMacros, :type => :controller

  # Database cleaner configuration

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation

    # Create terms and conditions
    Document.create(label: "t&c") do |doc|
      doc.title = "Terms and Conditions"
      doc.content = "blah blah blah"
    end

  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Controllers must render the content of the view
  config.render_views
end

RSpec.shared_context 'stub browser locale' do
  def set_browser_locale(locale)
    request.env["HTTP_ACCEPT_LANGUAGE"] = "#{locale}"
  end
end

RSpec.configure(&:infer_spec_type_from_file_location!)
