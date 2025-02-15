require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Timeoverflow
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # I18n configuration
    config.i18n.default_locale = :es
    config.i18n.available_locales = [:es, :ca, :eu, :gl, :en, :'pt-BR', :fr]
    config.i18n.fallbacks = true

    # This tells Rails to serve error pages from the app itself, rather than using static error pages in public/
    config.exceptions_app = self.routes

    # ActiveJob configuration
    config.active_job.queue_adapter = :sidekiq

    # ActionMailer background queues
    config.action_mailer.deliver_later_queue_name = :mailers

    # Use db/structure.sql with SQL as schema format
    # This is needed to store in the schema SQL statements not covered by the ORM
    config.active_record.schema_format = :sql

    # Guard against DNS rebinding attacks by permitting hosts
    # localhost is necessary for the docker image
    config.hosts = ENV.fetch('ALLOWED_HOSTS', 'localhost').split(' ')
  end
end
