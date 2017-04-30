####################################
# GEMS
####################################

gem 'bootstrap_form'
gem 'kaminari'
gem 'haml'

####################################
# CONFIG
####################################

append_to_file('.env', 'ADMIN_PASSWORD=password')

####################################
# AUTH
####################################

file 'app/controllers/concerns/admin_authenticable.rb', <<~'RUBY'
  module AdminAuthenticable
    def authenticate!
      return if session[:logged_in].present?

      session[:return_to] = request.url
      redirect_to [:new, :admin, :sessions]
    end
  end
RUBY

####################################
# ROUTES
####################################

route <<-'RUBY'
    namespace :admin do
      resource :sessions, only: [:new, :create, :destroy]
      root to: 'dashboard#show'
    end
RUBY

####################################
# SIMPLE CRUD
####################################

file 'app/controllers/concerns/simple_crud.rb', tt('simple_crud.rb')

####################################
# BASE CONTROLLER
####################################

file 'app/controllers/admin/base_controller.rb', <<~'RUBY'
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
# SESSIONS CONTROLLER
####################################

file 'app/controllers/admin/sessions_controller.rb', tt('sessions_controller.rb')
file 'app/views/admin/sessions/new.haml', tt('new.haml')

####################################
# SESSIONS CONTROLLER
####################################



####################################
# ASSETS
####################################

# insert_into_file 'config/webpack/shared.js', after: '  plugins: [' do
#   "new webpack.ProvidePlugin({jQuery: 'jquery'}),"
# end

run 'yarn add jquery jquery-ujs turbolinks bootstrap-sass'

file 'app/javascript/admin/admin.scss', <<~'SCSS'
  $icon-font-path: '~bootstrap-sass/assets/fonts/bootstrap/';
  @import '~bootstrap-sass/assets/stylesheets/_bootstrap.scss';
SCSS

file 'app/javascript/packs/admin.js', <<~'JAVASCRIPT'
  import 'admin/admin.scss'
  import * as $ from 'jquery'
  import 'jquery-ujs'
JAVASCRIPT
