# Uglifier is only used on the precompile phase, so we can require it conditionally
require "uglifier" if ENV["SECRET_KEY_BASE"] == "dummy"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # Compress CSS & JS using preprocessors only on the precompile phase
  if ENV["SECRET_KEY_BASE"] == "dummy"
    config.assets.js_compressor = Uglifier.new(harmony: true)
    config.assets.css_compressor = :sass
  end

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  config.asset_host = ENV.fetch("RAILS_ASSET_HOST", nil) if ENV["RAILS_ASSET_HOST"].present?

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = ENV.fetch("STORAGE_PROVIDER", :local)

  # Mount Action Cable outside main process or domain.
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = ENV.fetch("FORCE_SSL", "true") == "true"

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = if %w(debug info warn error fatal).include?(ENV.fetch("RAILS_LOG_LEVEL", nil))
                       ENV["RAILS_LOG_LEVEL"]
                     else
                       :info
                     end

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment).
  config.active_job.queue_adapter = ENV.fetch("QUEUE_ADAPTER", nil) if ENV["QUEUE_ADAPTER"].present?
  # config.active_job.queue_name_prefix = "timeoverflow_production"

  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = {
    host: ENV["MAIL_LINK_HOST"],
    protocol: ENV["MAIL_LINK_PROTO"] || "https"
  }

  smtp_env = Hash[ENV.map do |k, v|
    if /^SMTP_(.*)$/ === k
      [$1.downcase.to_sym, YAML.load(v)]
    end
  end.compact]

  if smtp_env.present?
    config.action_mailer.smtp_settings = smtp_env
  end

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end
