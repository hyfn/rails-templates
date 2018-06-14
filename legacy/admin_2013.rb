# TODO: staging environment, CDN, FactoryGirl, Spork, RSpec Support, ignore session secret, postmark

app_title = camelized.underscore.humanize.titlecase

####################################
# GEMS
####################################

gem 'mysql2'
gem 'foreigner'
gem 'squeel'
gem 'ransack'

gem 'newrelic_rpm'
gem 'airbrake'

gem 'andand'

gem 'inherited_resources'
gem 'has_scope'

gem 'haml', '>= 3.1.7'
gem 'simple_form', '>= 2.0.4'
gem 'carrierwave'
gem 'fog'
gem 'mini_magick'
gem 'kaminari'
gem 'bootstrap_kaminari'
gem 'bootstrap-sass', '>= 2.1.1.0'
gem 'bootstrap-datepicker-rails'
gem 'bootstrap-wysihtml5-rails'
gem 'comma'

gem 'memcachier'
gem 'dalli'

gem_group :assets do
  gem 'compass-rails'
  gem 'underscore-rails'
end

gem_group :production do
  gem 'puma', '>= 1.6.3'
end

gem_group :development do
  gem 'haml-rails', '>= 0.3.5'
  gem 'quiet_assets', '>= 1.0.1'
  gem 'better_errors', '>= 0.0.8'
  gem 'binding_of_caller', '>= 0.6.8', platform: :ruby
  gem 'rack-livereload'
  gem 'guard-livereload'
  gem 'meta_request', '0.2.1'
  gem 'commands'
end

gem_group :test do
  gem 'email_spec', '>= 1.4.0'
  gem 'shoulda-matchers'
  gem 'webmock'
  gem 'spork'
end

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails', '>= 4.1.0'
  gem 'pry'
  gem 'pry-remote'
  gem 'pry-rails'
  gem 'sextant'
end

####################################
# CONFIG, INITIALIZERS
####################################

# Simple form
generate :'simple_form:install', "--bootstrap"

# rspec
generate :'rspec:install'

# Airbrake initializer
initializer 'airbrake.rb', <<-RUBY
  Airbrake.configure do |config|
    config.api_key = ENV['AIRBRAKE_API_KEY']
  end
RUBY

initializer 'carrierwave.rb', <<-RUBY
CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
    :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY'],
    :region                 => 'us-east-1',
    # :host                   => "https://d1e3iwfphrf4uu.cloudfront.net",
  }
  config.fog_directory  = '#{app_name}-hyfn'
  config.fog_public     = true
  config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
end
RUBY

# Puma Initializer
file 'config/puma.rb', <<-'RUBY'
require "active_record"

cwd = File.dirname(__FILE__)+"/.."
ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"] || YAML.load_file("#{cwd}/config/database.yml")[ENV["RACK_ENV"]])

ActiveRecord::Base.verify_active_connections!
RUBY

# config files
inside "config" do
  # Generate YAML config
  config_yml = <<-YAML
CYBER_RISK_ANALYTICS_TOKEN:
NEWS_CRED_ACCESS_KEY:
AWS_ACCESS_KEY_ID:
AWS_SECRET_ACCESS_KEY:
ADMIN_PASSWORD:
AIRBRAKE_API_KEY:
CONTACT_EMAIL:
NEW_RELIC_APP_NAME: #{app_name}
NEWRELIC_DISPATCHER: pow
POW_WORKERS: "1"
YAML

  file 'env.yml', config_yml
  file 'env.sample.yml', config_yml

  run "curl https://raw.github.com/gist/2253296/newrelic.yml > newrelic.yml"
end

# Procfile
file "Procfile", 'web: bundle exec puma -p $PORT -e $RACK_ENV -C config/puma.rb'

####################################
# ENVIRONMENTS
####################################

environment <<-RUBY
    # rspec for tests, factory_girl for fixtures
    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl

      g.view_specs false
      g.helper_specs false
    end

    # autoload from libs dir
    config.autoload_paths += %W(\#{config.root}/lib)

    # cache with dalli
    config.cache_store = :dalli_store, {
      :expires_in => 1.hour,
      :namespace => "#{app_name}"
    }

    # compile assets on heroku
    config.assets.initialize_on_precompile = false
    # precompile top-level admin assets
    config.assets.precompile += %w( admin.css admin.js )

    # load configuration for config/env.yml
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end
RUBY

development_rb = <<-'RUBY'

# livereload!
config.middleware.insert_after(ActionDispatch::Static, Rack::LiveReload)

RUBY
environment development_rb, env: "development"

# TODO: consider setting up for CDN
production_rb = <<-'RUBY'

  # puma safe!
  config.threadsafe! unless defined?($rails_rake_task) && $rails_rake_task
RUBY
environment production_rb, env: "production"

run "cp config/environments/production.rb config/environments/staging.rb"

inside "app" do
  run "mkdir concerns && touch concerns/.gitkeep"
  run "mkdir uploaders && touch uploaders/.gitkeep"
  run "mkdir inputs"
end

####################################
# ADMIN ROUTES
####################################

route <<-'RUBY'
  namespace :admin do
    resource :sessions, only: [:new, :create, :destroy]
    root to: "dashboard#show"
  end
RUBY

####################################
# ADMIN ASSETS
####################################

# Admin JS

file 'app/assets/javascripts/admin.js.coffee', <<-'COFFEE-SCRIPT'
#= require jquery
#= require jquery_ujs
#= require bootstrap-button
#= require bootstrap-datepicker/core
#= require bootstrap-wysihtml5

window.log = -> @console?.log?(arguments...)

$ ->
  $("input.date_picker").datepicker
    format: "yyyy-mm-dd"
    weekStart: 1
    autoclose: true

  # photo editor
  $('.js-photo-edit').on 'click', (e) ->
    e.preventDefault()
    $container = $(this).closest('.js-photo-controls')
    $container.find('.js-photo-preview').fadeOut ->
      $container.find('.js-photo-fields').fadeIn()

  parserRules = $.fn.wysihtml5.defaultOptions.parserRules
  parserRules.tags.p = 1
  $('textarea.richtext').each -> $(@).wysihtml5
    image: false
    lists: false
    "font-styles": false
    html: true
    useLineBreaks: false
    parserRules: parserRules

  $(".media-format :radio").change -> toggleMediaType($(@).val())

  toggleMediaType = (val) ->
    $(".media-toggle").hide()
    $(".media-#{val}").show() if val

  $(".media-toggle").hide()
  toggleMediaType $(".media-format :radio:checked").val()
COFFEE-SCRIPT

# Admin CSS

file 'app/assets/stylesheets/admin.css.scss', <<-'SCSS'
@import "bootstrap";
body { padding-top: 60px; }
@import "bootstrap-datepicker";
@import "bootstrap-wysihtml5";

#login {
  background-color: #999;
}

.login-modal {
  @extend .modal;
}

.brand {
  width: 35px;
  height: 20px;
}

.hero {
  height: 200px;
  margin: -20px 0 20px 0;
  border-radius: 0;

  h1 {
    font-size: 60px;
    background: rgb(255,255,255);
    background: rgba(255,255,255,0.85);
    padding: 40px 80px;
    text-align: center;
    margin: 40px auto;
  }
}

h1 .btn {
  float: right;
}

.control-group.image .controls img {
  @extend .img-polaroid;
  margin: 0 12px 0 0;
}

.control-group.download .controls a.download-link {
  @extend .btn;
  margin: 0 12px 0 0;
}

.controls-row .span2 {
  margin: 5px 0 5px 0;
}
SCSS


####################################
# ADMIN CONCERNS
####################################

# Authenticable Module

file 'app/concerns/authenticable.rb', <<-'RUBY'
module Authenticable
  def authenticate!
    unless session[:logged_in]
      session[:return_to] = request.url
      redirect_to [:new, :admin, :sessions]
    end
  end
end
RUBY


####################################
# ADMIN CONTROLLERS
####################################

# Admin Dashboard Controller

file 'app/controllers/admin/dashboard_controller.rb', <<-'RUBY'
class Admin::DashboardController < ApplicationController
  include Authenticable
  layout "admin"
  before_filter :force_ssl, :authenticate!

  def show
  end
end
RUBY

# Admin Sessions Controller

file 'app/controllers/admin/sessions_controller.rb', <<-'RUBY'
class Admin::SessionsController < ApplicationController
  layout false
  before_filter :force_ssl

  def new
  end

  def create
    if params[:password] == ENV['ADMIN_PASSWORD']
      session[:logged_in] = true
      redirect_to session.delete(:return_to) || admin_root_path
    else
      render action: "new"
    end
  end

  def destroy
    session[:logged_in] = nil
    redirect_to [:new, :admin, :sessions]
  end
end
RUBY

# Base Admin Controller

file 'app/controllers/admin_resource_controller.rb', <<-'RUBY'
class AdminResourceController < InheritedResources::Base
  include Authenticable
  layout "admin"
  respond_to :html
  has_scope :page, :default => 1
  before_filter :force_ssl, :authenticate!
end
RUBY

# Update Application Controller

run "rm app/controllers/application_controller.rb"
file 'app/controllers/application_controller.rb', <<-'RUBY'
class ApplicationController < ActionController::Base
  protect_from_forgery

  def force_ssl
    unless request.ssl? || Rails.configuration.consider_all_requests_local
      redirect_to protocol: "https://"
    end
  end

  def cache(key, options = {}, &block)
    Rails.cache.fetch(key, options, &block)
  end
end
RUBY


####################################
# ADMIN SIMPLE FORM INPUTS
####################################

file 'app/inputs/date_picker_input.rb', <<-'RUBY'
class DatePickerInput < SimpleForm::Inputs::StringInput
  def input
    value = object.send(attribute_name) if object.respond_to? attribute_name
    input_html_options[:value] ||= I18n.localize(value) if value.present?
    input_html_classes << "datepicker"
    input_html_options[:type] = "text"

    super # leave StringInput do the real rendering
  end
end
RUBY

file 'app/inputs/download_input.rb', <<-'RUBY'
class DownloadInput < SimpleForm::Inputs::FileInput
  def input
    out = ''
    if object.send("#{attribute_name}?")
      out << template.link_to("Download", object.send(attribute_name).url, class: "download-link")
    end
    (out << super).html_safe
  end
end
RUBY

file 'app/inputs/image_input.rb', <<-'RUBY'
class ImageInput < SimpleForm::Inputs::FileInput
  def input
    version = input_html_options.delete(:preview_version)
    use_default_url = options.delete(:use_default_url) || false

    out = ''
    if object.send("#{attribute_name}?") || use_default_url
      out << template.image_tag(object.send(attribute_name).tap {|o| break o.send(version) if version}.send('url'))
    end
    (out << super).html_safe
  end
end
RUBY

file 'app/inputs/richtext_input.rb', <<-'RUBY'
class RichtextInput < SimpleForm::Inputs::TextInput
  def input_html_classes
    super.push('richtext span8')
  end
end
RUBY

file 'app/inputs/string_input.rb', <<-'RUBY'
class StringInput < SimpleForm::Inputs::StringInput
  def input_html_classes
    super.push('span8')
  end
end
RUBY

file 'app/inputs/text_input.rb', <<-'RUBY'
class TextInput < SimpleForm::Inputs::TextInput
  def input_html_classes
    super.push('span8')
  end
end
RUBY


####################################
# ADMIN VIEWS
####################################

file 'app/views/admin/dashboard/show.html.haml', <<-HAML
- content_for :top do
  .hero
    .container
      %h1
        #{app_title}
        %small Configuration CMS
HAML

file 'app/views/admin/sessions/new.html.haml', <<-HAML
!!!
%html
  %head
    %title #{app_title} Admin
    = stylesheet_link_tag    "admin"
    = javascript_include_tag "admin"
    = csrf_meta_tags
  %body#login
    = form_tag [:admin, :sessions], class: "form-horizontal" do
      .login-modal
        .modal-header
          %h1 Sign In
        .modal-body
          .control-group
            %label.control-label{for: "password"} Password
            .controls
              %input#password{placeholder: "Password", type: "password", name: "password"}
        .modal-footer
          %button.btn.btn-primary{type: "submit"} Sign in
HAML

file 'app/views/layouts/admin.html.haml', <<-HAML
!!!
%html
  %head
    %title #{app_title} Admin
    /javascript
    / window.globals = \#{js_globals};
    = stylesheet_link_tag    "admin"
    = javascript_include_tag "admin"
    = csrf_meta_tags
  %body{class: %w(controller action id).map { |param| params[param].to_s.cssify }.reject(&:blank?)}
    .navbar.navbar-fixed-top
      .navbar-inner
        .container
          .brand
          %ul.nav
            %li= link_to "Analytics", "#"
            %li= link_to "Go to the App", "#"
          %ul.nav.pull-right
            %li.divider-vertical
            %li= link_to "Log Out", [:admin, :sessions] , method: "delete"
    = yield :top
    .container
      .row
        .span3
          %ul#left-nav.nav.nav-tabs.nav-stacked.affix.span3
            %li= link_to "Dashboard", "#"
        .span9
          #main= yield

HAML


####################################
# UTILS
####################################

run "rm .rspec"
file ".rspec", "--colour --drb --format documentation -p"
run "curl https://raw.github.com/RailsApps/rails-composer/master/files/gitignore.txt > .gitignore"

run "powder link" if yes? "Create dev app via pow at '#{app_name}.dev' ?"

if yes? "Create Heroku app at #{app_name}.herokuapp.com?"
  git :init
  remote = "heroku"

  if yes? "Create staging Heroku app at #{app_name}-stage.herokuapp.com?"
    remote = "production"
    run "heroku create #{app_name}-stage -r staging"
  end

  run "heroku create #{app_name} -r #{remote}"
end
