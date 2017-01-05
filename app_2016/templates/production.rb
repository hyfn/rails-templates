Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Only serve static files if using nginx buildpack
  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Set headers if using nginx buildpack
  if ENV['RAILS_SERVE_STATIC_FILES'].present?
    config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX
  else
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=31557600",
    }
  end

  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :sass
  config.assets.compile = false
  config.assets.digest = true

  # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  config.force_ssl = true
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment)
  # config.active_job.queue_adapter     = :sidekiq
  # config.active_job.queue_name_prefix = "#{Rails.env}"

  config.action_mailer.perform_caching = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  config.action_controller.asset_host = "https://#{ENV['CDN_HOST']}"

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  config.action_mailer.smtp_settings = {
    address: 'smtp.sendgrid.net',
    port: '587',
    authentication: :plain,
    user_name: ENV['SENDGRID_USERNAME'],
    password: ENV['SENDGRID_PASSWORD'],
    domain: 'heroku.com',
    enable_starttls_auto: true,
  }

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end
end
