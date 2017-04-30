####################################
# GEMS
####################################

gem 'bootstrap_form'
gem 'kaminari'
gem 'haml', '~> 5.0'

####################################
# CONFIG
####################################

append_to_file '.env', 'ADMIN_PASSWORD=password'

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
# CONTROLLER MIXINS
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

copy_file 'admin_crud.rb', 'app/controllers/concerns/admin_crud.rb'
copy_file 'admin_enableable.rb', 'app/controllers/concerns/admin_enableable.rb'
copy_file 'admin_pagination.rb', 'app/controllers/concerns/admin_pagination.rb'
copy_file 'admin_sequenceable.rb', 'app/controllers/concerns/admin_sequenceable.rb'

####################################
# CONTROLLERS
####################################

copy_file 'admin.haml', 'app/views/layouts/admin.haml'

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

copy_file 'sessions_controller.rb', 'app/controllers/admin/sessions_controller.rb'
copy_file 'new.haml', 'app/views/admin/sessions/new.haml'

copy_file 'dashboard_controller.rb', 'app/controllers/admin/dashboard_controller.rb'
copy_file 'dashboard.haml', 'app/views/admin/dashboard/show.haml'

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
  import Turbolinks from 'turbolinks'

  // TODO: fix these
  // import 'bootstrap/js/dropdown'
  // import 'bootstrap/js/modal'
  // import 'bootstrap/js/tooltip'
  // import 'bootstrap/js/popover'
  // import 'bootstrap/js/alert'
  // import 'bootstrap/js/transition'
  // import 'bootstrap/js/carousel'

  Turbolinks.start()

  document.addEventListener('DOMContentLoaded', () => {
    // once ever
  })

  document.addEventListener('turbolinks:load', () => {
    // every page
  })
JAVASCRIPT
