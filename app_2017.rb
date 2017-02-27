app_title = camelized.underscore.humanize.titlecase

TEMPLATE_BINDING = binding

def tt(name, type  = nil)
  path = File.expand_path(File.join(File.dirname(__FILE__), 'app_2016', 'templates', name))

  case type
  when :erb
    ERB.new(File.read(path)).result(TEMPLATE_BINDING)
  when :qq
    TEMPLATE_BINDING.eval(%(<<-"PORKSTRINGER"\n#{File.read(path)}\nPORKSTRINGER))
  else
    File.read(path)
  end
end

####################################
# GEMS
####################################

file 'Gemfile', tt('Gemfile', :erb), force: true

####################################
# REMOVE SECRETS.YML
####################################

run 'rm config/secrets.yml'

####################################
# DOTENV
####################################

file '.env', tt('dotenv', :qq)
file 'example.env', tt('dotenv', :qq)

####################################
# DATABASE.YML
####################################

file 'config/database.yml', tt('database.yml'), force: true

####################################
# DEVELOPMENT ENVIRONMENT
####################################

file 'config/environments/development.rb', tt('development.rb'), force: true

####################################
# PRODUCTION / STAGING ENVIRONMENTS
####################################

file 'config/environments/production.rb', tt('production.rb'), force: true
file 'config/environments/staging.rb', tt('production.rb'), force: true

####################################
# APP CONFIG
####################################

environment <<-'RUBY'
    config.secret_token = ENV.fetch('SECRET_TOKEN')
    config.autoload_paths <<  Rails.root.join('app','services')
    config.autoload_paths <<  Rails.root.join('app','uploaders')
    config.action_mailer.default_url_options = { host: ENV.fetch('APPLICATION_HOST') }
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

    Rails.application.routes.default_url_options[:host] = ENV.fetch('APPLICATION_HOST')
RUBY

####################################
# PUMA CONFIG
####################################

file 'config/puma.rb', tt('puma.rb'), force: true

####################################
# MORALITY POLICE
####################################

file '.rubocop.yml', tt('rubocop.yml')

####################################
# NGINX CONFIG
####################################

file 'config/nginx.conf.erb', tt('nginx.conf')

####################################
# NEWRELIC CONFIG
####################################

file 'config/newrelic.yml', tt('newrelic.yml', :qq)

####################################
# RSPEC GENERATOR
####################################

generate('rspec:install')

####################################
# ADMIN AUTH
####################################

file 'app/controllers/concerns/admin_authenticable.rb', <<-'RUBY'
module AdminAuthenticable
  def authenticate!
    return if session[:logged_in].present?

    session[:return_to] = request.url
    redirect_to [:new, :admin, :sessions]
  end
end
RUBY

####################################
# ADMIN ASSETS
####################################

file 'config/initializers/assets.rb', <<-'RUBY', force: true
Rails.application.config.assets.version = ENV["ASSETS_VERSION"] || '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

Rails.application.config.assets.precompile += %w(admin.css admin.js)
RUBY

####################################
# ADMIN ROUTES
####################################

route <<-'RUBY'
    namespace :admin do
      resource :sessions, only: [:new, :create, :destroy]
    end
RUBY

####################################
# ADMIN SIMPLE CRUD
####################################

file 'app/controllers/concerns/simple_crud.rb', tt('simple_crud.rb')

####################################
# ADMIN BASE CONTROLLER
####################################

file 'app/controllers/admin/base_controller.rb', <<-'RUBY'
module Admin
  class BaseController < ApplicationController
    include AdminAuthenticable
    # include AdminSource
    before_action :authenticate!
    # before_action :ensure_admin_domain

    layout 'admin'
  end
end
RUBY

####################################
# ADMIN SESSIONS CONTROLLER
####################################

file 'app/controllers/admin/sessions_controller.rb', tt('sessions_controller.rb')
file 'app/views/admin/sessions/new.haml', tt('new.haml')

####################################
# ADMIN STYLESHEET
####################################

file 'app/assets/stylesheets/admin.scss', <<-'SCSS'
@import "bootstrap-sprockets";
@import "bootstrap";
SCSS

file 'app/assets/javascripts/admin.js.es6', <<-'JAVASCRIPT'
// require almond
//= require jquery
//= require jquery-ujs
// require bootstrap/collapse
// require bootstrap/dropdown
// require bootstrap/alert
// require bootstrap/tooltip
// require bootstrap/popover
JAVASCRIPT

####################################
# GITIGNORES
####################################

after_bundle do
  run('echo .DS_STORE >> .gitignore')
  run('echo .env >> .gitignore')
  run('echo /.vagrant/ >> .gitignore')
  run('echo .ruby-gemset >> .gitignore')
end

####################################
# PROCFILE
####################################

file 'Procfile', <<-'TXT'
  web: bin/start-nginx bundle exec puma -C config/puma.rb
TXT

####################################
# README
####################################

file 'README.md', tt('README.md', :qq), force: true

####################################
# HEROKU REMOTES
####################################

after_bundle do
  git :init

  %w(production staging dev).each do |env|
    next unless yes?("Link to #{env} Heroku app?")
    default_app_name = app_name
    default_app_name += "-#{env}" unless env == 'production'
    heroku_app_name = ask('What is the app named?', default: default_app_name)
    run "heroku git:remote -a #{heroku_app_name} -r #{env}"
    run "heroku buildpacks:set --index 1 heroku/ruby -r #{env}"
    run "heroku buildpacks:set --index 2 https://github.com/gunpowderlabs/buildpack-ruby-rake-deploy-tasks -r #{env}"
    run "heroku buildpacks:set --index 3 https://github.com/beanieboi/nginx-buildpack -r #{env}"
  end
end
