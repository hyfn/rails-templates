require 'fileutils'
require 'shellwords'
require 'tmpdir'

app_title = camelized.underscore.humanize.titlecase
CONTEXT = instance_eval('binding')

def string_template(source, *args)
  copy_file(source, *args) do |contents|
    CONTEXT.eval(%(<<-"PORKSTRINGER"\n#{contents}\nPORKSTRINGER))
  end
end

# ganked from https://github.com/mattbrictson/rails-template/
def source_dir
  return File.dirname(__FILE__) unless __FILE__ =~ %r{\Ahttps?://}

  tmpdir = Dir.mktmpdir('rails-template-')
  at_exit { FileUtils.remove_entry(tmpdir) }

  git clone: [
    '--quiet',
    'https://github.com/hyfn/rails-templates.git',
    tmpdir,
  ].map(&:shellescape).join(' ')
  tmpdir
end

source_paths.unshift(File.join(source_dir, 'app_2020', 'templates'))

####################################
# GEMS
####################################

copy_file 'Gemfile', force: true

####################################
# REMOVE SECRETS.YML
####################################

# remove_file 'config/secrets.yml'

####################################
# DOTENV
####################################

string_template 'dotenv', '.env'
# TODO: maybe make an example here?
string_template 'dotenv', '.env.local'

####################################
# DATABASE.YML
####################################

copy_file 'database.yml', 'config/database.yml', force: true

####################################
# DEVELOPMENT ENVIRONMENT
####################################

copy_file 'development.rb', 'config/environments/development.rb', force: true

####################################
# PRODUCTION / STAGING ENVIRONMENTS
####################################

copy_file 'production.rb', 'config/environments/production.rb', force: true
copy_file 'production.rb', 'config/environments/staging.rb', force: true

####################################
# APP CONFIG
####################################

# TODO: see what's actually needed in Rails 5.2

# environment <<~'RUBY'
#       config.secret_token = ENV.fetch('SECRET_TOKEN')
#       config.autoload_paths <<  Rails.root.join('app', 'services')
#       config.autoload_paths <<  Rails.root.join('app', 'serializers')
#       config.autoload_paths <<  Rails.root.join('app', 'uploaders')
#       config.action_mailer.default_url_options = { host: ENV.fetch('APPLICATION_HOST') }
#       config.generators do |generate|
#         generate.helper false
#         generate.javascript_engine false
#         generate.request_specs true
#         generate.controller_specs false
#         generate.routing_specs false
#         generate.stylesheets false
#         generate.test_framework :rspec
#         generate.view_specs false
#       end

#       config.action_controller.action_on_unpermitted_parameters = :raise

#       Rails.application.routes.default_url_options[:host] = ENV.fetch('APPLICATION_HOST')
# RUBY

####################################
# PUMA CONFIG
####################################

copy_file 'puma.rb', 'config/puma.rb', force: true

####################################
# MORALITY POLICE
####################################

copy_file 'rubocop.yml', '.rubocop.yml'
string_template 'circle.yml', '.circleci/config.yml'

####################################
# NGINX CONFIG
####################################

copy_file 'nginx.conf', 'config/nginx.conf.erb'

####################################
# NEWRELIC CONFIG
####################################

string_template 'newrelic.yml', 'config/newrelic.yml'

####################################
# RSPEC GENERATOR
####################################

after_bundle do
  generate('rspec:install')
  copy_file 'spec/rails_helper.rb', 'spec/rails_helper.rb', force: true
  copy_file 'spec/common_helpers.rb', 'spec/support/common_helpers.rb'
  copy_file 'spec/request_helpers.rb', 'spec/support/request_helpers.rb'
end

####################################
# RAKE TASKS
####################################

copy_file 'db.rake', 'lib/tasks/db.rake'
copy_file 'auto_annotate_models.rake', 'lib/tasks/auto_annotate_models.rake'

####################################
# YARN
####################################

after_bundle do
  run "yarn"
end

####################################
# GITIGNORES
####################################

after_bundle do
  run('echo .DS_STORE >> .gitignore')
  run('echo .env.local >> .gitignore')
  run('echo /.vagrant/ >> .gitignore')
  run('echo .ruby-gemset >> .gitignore')
  run('echo /.vscode/ >> .gitignore')
end

####################################
# PROCFILE
####################################

create_file 'Procfile', <<~'TXT'
  web: bin/start-nginx bundle exec puma -C config/puma.rb
TXT

create_file 'Procfile.dev', <<~'TXT'
  rails: ./bin/rails server -b 0.0.0.0 -p 3000
  webpack: ./bin/webpack-dev-server --host 0.0.0.0
TXT

####################################
# README
####################################

string_template 'README.md', force: true

####################################
# HEROKU REMOTES
####################################

after_bundle do
  # git :init

  # %w(production staging dev).each do |env|
  #   next unless yes?("Link to #{env} Heroku app?")
  #   default_app_name = app_name
  #   default_app_name += "-#{env}" unless env == 'production'
  #   heroku_app_name = ask('What is the app named?', default: default_app_name)
  #   run "heroku git:remote -a #{heroku_app_name} -r #{env}"
  #   run "heroku buildpacks:set --index 1 heroku/nodejs -r #{env}"
  #   run "heroku buildpacks:set --index 2 heroku/ruby -r #{env}"
  #   run "heroku buildpacks:set --index 3 https://github.com/gunpowderlabs/buildpack-ruby-rake-deploy-tasks -r #{env}"
  #   run "heroku buildpacks:set --index 4 https://github.com/hyfn/nginx-buildpack -r #{env}"
  # end
end
