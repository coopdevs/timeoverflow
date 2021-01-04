require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Timeoverflow
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.default_locale = :es
    config.i18n.available_locales = [:es, :ca, :eu, :gl, :en, :'pt-BR']
    config.i18n.fallbacks = true

    # This tells Rails to serve error pages from the app itself, rather than using static error pages in public/
    config.exceptions_app = self.routes

    # Activate the Skylight agent in staging. You need to provision the
    # SKYLIGHT_AUTHENTICATION env var for this to work.
    config.skylight.environments += ["staging"]

    # ActiveJob configuration
    config.active_job.queue_adapter = :sidekiq

    # Use db/structure.sql with SQL as schema format
    # This is needed to store in the schema SQL statements not covered by the ORM
    config.active_record.schema_format = :sql

    # Guard against DNS rebinding attacks by permitting hosts
    config.hosts << /timeoverflow\.(local|org)/
  end
end
