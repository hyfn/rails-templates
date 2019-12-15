RAILS_ENV = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'

workers Integer(ENV['WEB_CONCURRENCY'] || 1)
threads_count = Integer(ENV['MAX_THREADS'] || RAILS_ENV == 'development' ? 5 : 10)
threads threads_count, threads_count

preload_app!

rackup DefaultRackup
bind RAILS_ENV == 'development' ? 'tcp://localhost:3000' : 'unix:///tmp/nginx.socket'
environment RAILS_ENV

worker_timeout 3600 if RAILS_ENV == 'development'

before_fork do
  if RAILS_ENV == 'production'
    require 'puma_worker_killer'
    PumaWorkerKiller.enable_rolling_restart(3600)
  end
  ActiveRecord::Base.connection_pool.disconnect!
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
