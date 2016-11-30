app_title = camelized.underscore.humanize.titlecase

####################################
# GEMS
####################################

file 'Gemfile', <<-'RUBY', force: true
source 'https://rubygems.org'

ruby '2.3.1'

# Basics
gem 'rails'
gem 'pg'
gem 'puma'

# Asset Management
gem 'aws-sdk'
gem 'mini_magick'

# Monitoring
gem 'newrelic_rpm'
gem 'sentry-raven'

# Frontend Common
gem 'sprockets-es6'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'autoprefixer-rails'

# Admin
gem 'bootstrap-sass', '~> 3.3.5'
gem 'bootstrap_form'
gem 'kaminari'
gem 'haml'

gem 'parallel', require: false

source 'https://rails-assets.org' do
  # Bower libraries
  gem 'rails-assets-normalize.css'
  gem 'rails-assets-jquery'
  gem 'rails-assets-jquery-ujs'
  gem 'rails-assets-almond'
end

group :production, :staging do
  gem 'puma_worker_killer'
  gem 'rails_12factor'
  gem 'dalli'
end

group :development do
  gem 'web-console'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'rubocop'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.5'
  gem 'pry-rails'
  gem 'dotenv-rails'
  gem 'fabrication'
  gem 'ffaker'
  gem 'fuubar'

  gem 'bullet'
  gem 'bundler-audit', '>= 0.5.0', require: false
end

group :test do
  gem 'database_cleaner'
  gem 'timecop'
  gem 'webmock'
end
RUBY

####################################
# DOTENV
####################################

dotenv = <<-'BASH'
DEVISE_SECRET=FILL_ME_IN
SECRET_KEY_BASE=FILL_ME_IN

AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=FILL_ME_IN
AWS_SECRET_ACCESS_KEY=FILL_ME_IN
AWS_S3_BUCKET_NAME=FILL_ME_IN
BUCKET_CDN_HOST=FILL_ME_IN

SENTRY_DSN=FILL_ME_IN
SENDGRID_PASSWORD=FILL_ME_IN
SENDGRID_USERNAME=FILL_ME_IN

MAILER_DEFAULT_HOST=localhost:3000
BASH

file '.env', dotenv
file 'example.env'

####################################
# DEVELOPMENT ENVIRONMENT
####################################

file 'config/environments/development.rb', <<-'RUBY', force: true
Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.quiet = true
  config.action_view.raise_on_missing_translations = true
  config.action_mailer.default_url_options = { host: "localhost:3000" }
end
RUBY

####################################
# PRODUCTION / STAGING ENVIRONMENTS
####################################

live_config = <<-'RUBY'
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
  config.action_controller.asset_host = "https://#{ENV['CDN_HOST']}"

  config.active_job.queue_adapter     = :sidekiq
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
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end
end
RUBY

file 'config/environments/production.rb', live_config, force: true
file 'config/environments/staging.rb', live_config, force: true

####################################
# APP CONFIG
####################################

environment <<-'RUBY'
    config.autoload_paths <<  Rails.root.join('app','services')
    config.autoload_paths <<  Rails.root.join('app','uploaders')
    config.action_mailer.default_url_options = { host: ENV['HOST_URL'] }
    config.assets.quiet = true
    config.generators do |generate|
      generate.helper false
      generate.javascript_engine false
      generate.request_specs true
      generate.controller_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
    end
    config.action_controller.action_on_unpermitted_parameters = :raise

    Rails.application.routes.default_url_options[:host] = ENV['HOST_URL']
RUBY

####################################
# PUMA CONFIG
####################################

file 'config/puma.rb', <<-'RUBY', force: true

workers Integer(ENV['WEB_CONCURRENCY'] || 1)
threads_count = Integer(ENV['MAX_THREADS'] || 10)
threads threads_count, threads_count

preload_app!

rackup DefaultRackup
bind 'unix:///tmp/nginx.socket'
environment ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'production'

before_fork do
  require 'puma_worker_killer'
  PumaWorkerKiller.enable_rolling_restart(3600)
end

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end

on_worker_fork do
  # for heroku nginx
  FileUtils.touch('/tmp/app-initialized')
end

plugin :tmp_restart
RUBY

####################################
# MORALITY POLICE
####################################

file '.rubocop.yml', <<-'YAML'
Rails/HasAndBelongsToMany:
  Enabled: false
Rails/Output:
  Exclude:
    - 'db/**/seeds.rb'
    - 'lib/tasks/**/*'
Metrics/BlockLength:
  Exclude:
    - 'db/**/seeds.rb'
    - 'lib/tasks/**/*'
Style/Documentation:
  Enabled: false
Rails:
  Enabled: true
Style/FrozenStringLiteralComment:
  Enabled: false
Metrics/AbcSize:
  Enabled: false
Metrics/MethodLength:
  Enabled: false
Metrics/ClassLength:
  Enabled: false
Style/ClassAndModuleChildren:
  Enabled: false
Metrics/LineLength:
  Max: 120
Style/TrailingCommaInArguments:
  EnforcedStyleForMultiline: comma
Style/TrailingCommaInLiteral:
  EnforcedStyleForMultiline: comma
Metrics/CyclomaticComplexity:
  Enabled: false
Style/AccessorMethodName:
  Enabled: false
Style/StringLiterals:
  Enabled: false
Style/SpaceBeforeBlockBraces:
  Exclude:
    - 'spec/**/**'
Style/SpaceInsideBlockBraces:
  Exclude:
    - 'spec/**/**'
Style/DoubleNegation:
  Enabled: false
Metrics/BlockLength:
  Exclude:
    - 'spec/**/**'
Bundler/OrderedGems:
  Enabled: false
AllCops:
  Exclude:
    - db/schema.rb
    - config/environments/**
    - db/migrate/**
    - bin/**
  TargetRubyVersion: 2.3
YAML

####################################
# NGINX CONFIG
####################################

file 'config/nginx.conf.erb', <<-'ERB'
daemon off;
#Heroku dynos have at least 4 cores.
worker_processes <%= ENV['NGINX_WORKERS'] || 4 %>;

events {
  use epoll;
  accept_mutex on;
  worker_connections 1024;
}

http {
  gzip on;
  gzip_http_version  1.0;
  gzip_comp_level 5;
  gzip_min_length 256;
  gzip_proxied any;
  gzip_vary on;
  gzip_types
    application/atom+xml
    application/javascript
    application/json
    application/rss+xml
    application/vnd.ms-fontobject
    application/x-font-ttf
    application/x-web-app-manifest+json
    application/xhtml+xml
    application/xml
    font/opentype
    image/svg+xml
    image/x-icon
    text/css
    text/plain
    text/x-component;

  server_tokens off;

  proxy_cache_path /tmp/nginx levels=1:2 keys_zone=app:8m max_size=1000m inactive=600m use_temp_path=off;
  proxy_temp_path /tmp/nginx_temp;

  log_format l2met 'measure#nginx.service=$request_time request_id=$http_x_request_id';
  access_log logs/nginx/access.log;
  error_log logs/nginx/error.log;

  include mime.types;
  default_type application/octet-stream;
  sendfile on;

  #Must read the body in 5 seconds.
  client_body_timeout <%= ENV['NGINX_CLIENT_BODY_TIMEOUT'] || 5 %>;

  upstream app_server {
    server unix:/tmp/nginx.socket fail_timeout=0;
  }

  server {
    listen <%= ENV["PORT"] %>;
    server_name _;
    keepalive_timeout 5;
    client_max_body_size <%= ENV['NGINX_CLIENT_MAX_BODY_SIZE'] || 1 %>M;

    root /app/public;

    location ~* ^/assets/ {
      gzip_static on;

      add_header Access-Control-Allow-Origin *;
      add_header Cache-Control public;
      expires max;

      # Some browsers still send conditional-GET requests if there's a
      # Last-Modified header or an ETag header even if they haven't
      # reached the expiry date sent in the Expires header.
      add_header Last-Modified "";
      add_header ETag "";
      break;
    }

    location / {
      proxy_http_version 1.1;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Host $http_host;
      # proxy_set_header X-Forwarded-Proto https;
      proxy_redirect off;

      add_header X-Proxy-Cache $upstream_cache_status;
      proxy_cache_lock on;
      proxy_cache_lock_age 1s;
      proxy_cache_revalidate on;
      proxy_cache_key "$scheme$request_method$host$request_uri";
      proxy_cache app;

      proxy_pass http://app_server;
    }
  }
}
ERB

####################################
# NEWRELIC CONFIG
####################################
file 'config/newrelic.yml', <<-YAML
common: &default_settings
  # Required license key associated with your New Relic account.
  license_key: <%= ENV['NEW_RELIC_LICENSE_KEY'] %>

  # Your application name. Renaming here affects where data displays in New
  # Relic.  For more details, see https://docs.newrelic.com/docs/apm/new-relic-apm/maintenance/renaming-applications
  app_name: #{app_title} Production

  # To disable the agent regardless of other settings, uncomment the following:
  # agent_enabled: false

  # Logging level for log/newrelic_agent.log
  log_level: info


# Environment-specific settings are in this section.
# RAILS_ENV or RACK_ENV (as appropriate) is used to determine the environment.
# If your application has other named environments, configure them here.
development:
  <<: *default_settings
  app_name: #{app_title} Development

  # NOTE: There is substantial overhead when running in developer mode.
  # Do not use for production or load testing.
  developer_mode: true

test:
  <<: *default_settings
  # It doesn't make sense to report to New Relic from automated test runs.
  monitor_mode: false

staging:
  <<: *default_settings
  app_name: #{app_title} Staging

production:
  <<: *default_settings
YAML

####################################
# RSPEC GENERATOR
####################################

generate('rspec:install')

####################################
# RSPEC GENERATOR
####################################

after_bundle do
  run('echo .DS_STORE >> .gitignore')
  run('echo .env >> .gitignore')
  run('echo /.vagrant/ >> .gitignore')
  run('echo .ruby-gemset >> .gitignore')
end
