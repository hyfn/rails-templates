####################################
# GEMS
####################################

gem 'newrelic_rpm'
gem 'sentry_raven'

gem 'aws-sdk'
gem 'mini_magick'

gem 'sprockets-es6'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'autoprefixer-rails'

gem 'bootstrap-sass', '~> 3.3.5'
gem 'bootstrap_form'
gem 'kaminari'
gem 'haml'

gem 'parallel', require: false

add_source 'https://rails-assets.org' do
  gem 'rails-assets-normalize.css'
  gem 'rails-assets-jquery'
  gem 'rails-assets-jquery-ujs'
  gem 'rails-assets-almond'
end

gem_group :production, :staging do
  gem 'puma_worker_killer'
  gem 'rails_12factor'
  gem 'dalli'
end

gem_group :development do
  gem 'web-console'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'rubocop'
end

gem_group :development, :test do
  gem 'rspec-rails', '~> 3.5'
  gem 'pry-rails'
  gem 'dotenv-rails'
  gem 'fabrication'
  gem 'ffaker'
  gem 'fuubar'

  gem 'bullet'
  gem 'bundler-audit', '>= 0.5.0', require: false
end

gem_group :test do
  gem 'database_cleaner'
  gem 'timecop'
  gem 'webmock'
end

####################################
# DEVELOPMENT ENVIRONMENT
####################################
