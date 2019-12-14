# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

ActiveRecord::Migration.maintain_test_schema!
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
RSpec.configure do |config|
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # TODO: enable this line if OmniAuth used
  # OmniAuth.config.test_mode = true

  config.include CommonHelpers
  config.include RequestHelpers, type: :request
end
