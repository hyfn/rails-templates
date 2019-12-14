Rails.application.configure do
  config.webpacker.check_yarn_integrity = false

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Only serve static files if using nginx buildpack
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Set headers if using nginx buildpack
  if ENV['RAILS_SERVE_STATIC_FILES'].present?
    config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX
  else
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=31557600',
    }
  end

  # Store uploaded files on the local file system (see config/storage.yml for options)
  # TODO: this will break stuff
  # config.active_storage.service = :amazon

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  config.action_controller.asset_host = "https://#{ENV['CDN_HOST']}"

  config.action_controller.default_url_options = { host: ENV['APPLICATION_HOST'] }

  # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  config.force_ssl = true
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  # Use a different cache store in production.
  config.cache_store = :dalli_store, (ENV["MEMCACHIER_SERVERS"] || "").split(","), {
    namespace: 'westdermatology',
    expires_in: 1.day,
    compress: true,
    username: ENV["MEMCACHIER_USERNAME"],
    password: ENV["MEMCACHIER_PASSWORD"],
    failover: true,
    socket_timeout: 1.5,
    socket_failure_delay: 0.2,
    down_retry_delay: 60,
  }

  # Use a real queuing backend for Active Job (and separate queues per environment)
  # config.active_job.queue_adapter = :sidekiq
  # config.active_job.queue_name_prefix = "#{Rails.env}"

  config.action_mailer.perform_caching = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # TODO: enable postmark
  # config.action_mailer.delivery_method = :postmark
  # config.action_mailer.postmark_settings = { :api_token => ENV['POSTMARK_API_KEY'] }

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end
