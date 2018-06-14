require 'fileutils'
require 'shellwords'

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

source_paths.unshift(File.join(source_dir, 'admin_2018'))

####################################
# GEMS
####################################
gem 'bootstrap_form'
gem 'kaminari'
gem 'haml', '~> 5.0'
gem 'devise'
gem 'rails-i18n'

gem_group :development do
  gem 'i18n-tasks'
end

run 'spring stop'
run 'bundle install'
# after_bundle do
# end
generate('devise:install') ## TODO figure out how to get bundle and after_bundle to work...
gsub_file 'config/initializers/devise.rb', /# config\.secret_key = .*/, "config.secret_key = ENV['DEVISE_SECRET']"

####################################
# CONFIG
####################################

append_to_file '.env' do <<-'TEXT'
IMAGE_RESIZE_URL=FILL_ME_IN
# DON'T ADD IT HERE! Copy this file to .env.local and add it there
# IMAGE_RESIZE_SECRET=FILL_ME_IN
# DON'T ADD IT HERE! Copy this file to .env.local and add it there
# DEVISE_SECRET=FILL_ME_IN
TEXT
end

####################################
# ROUTES
####################################

route <<-'RUBY'
  concern :enableable do
    patch :enable, on: :member
    patch :disable, on: :member
  end

  concern :sequenceable do
    patch :promote, on: :member
    patch :demote, on: :member
    patch :reorder_all, on: :collection
  end

  namespace :admin do
    resources :locations, concerns: [:enableable, :sequenceable]
    resources :fake_things, concerns: [:enableable, :sequenceable]
    root to: 'dashboard#show'
  end

  get :about, to: 'pages#about'
  root to: 'pages#home'
RUBY

####################################
# COPY CONFIG
####################################

environment <<~'RUBY'
  # specify locales avaialable to rails-i18n gem
  config.i18n.available_locales = [:en, :es]
RUBY
directory 'config/locales', 'config/locales'

# copy_file 'config/webpack/environment.js', 'config/webpack/environment.js', force: true

####################################
# COPY STUB MIGRATIONS
####################################
directory 'db/migrate', 'db/migrate', recursive: true, verbose: true # TODO make other migrations not hard coded
generate 'devise AdminUser'
directory 'spec/fabricators', 'spec/fabricators', recursive: true, verbose: true

####################################
# COPY APP CODE HIERARCHY
####################################
directory 'app', 'app', recursive: true, verbose: true

####################################
# COPY LIB HIERARCHY
####################################
directory 'lib', 'lib', recursive: true, verbose: true

####################################
# JS
####################################
run 'yarn add bootstrap@3 bootstrap-sass jquery jquery-ujs turbolinks'

####################################
# APPEND TO EXISTING README
####################################
append_to_file 'README.md' do <<-'TEXT'
### I18n
- This codebase uses yaml based i18n.  Two locales are configured: English `en` and Spanish `es`.  To adjust available locales, change `config.i18n.available_locales` in `config/application.rb`.
- In the development gems there is https://github.com/glebm/i18n-tasks , this can be used to figure out which translations are missing, etc.
- If database backed translations are required, check out other projects like Vita Coco or HPE for inspiration.

### Assets
Images and Fonts can be stored in `app/javascripts/images` and `app/javascript/fonts`.  Images that you want to be handled by webpack have to be manually imported/referenced within the JavaScript.
Example: `import 'images/some_image.jpg`

##### Webpack Assets Example
  - For an image: `app/javascripts/images/blah/something.jpg`
    - Import in JS with `import 'images/blah/something.jpg'`.
    - In Rails helpers and controllers, `<%= asset_path_pack 'images/blah/something.jpg' %>`.
    - In Rails but without path helpers (i.e. models), `Webpacker.manifest.lookup('images/blah/something.jpg')`.

##### Hyrez
  - Many images in the app are processed using a service this app is hooked up to: https://github.com/hyfn/hyrez .  The following must be specified in environment variables: `IMAGE_RESIZE_URL` and `IMAGE_RESIZE_SECRET`.
  - Methods in `app/helper/responsive_helper.rb` utilize the service.  Examples:
    ```
    srcset_tag - creates an img tag with a srcset
    picture_tag - picture tag given set of crops and sizes
    responsive_breakpoints - css helper
    responsive_image_css - css helper
    ```
  - Also check out `app/services/dynamic_image.rb` to see how hyrez works.

###### Hyrez + Image Assets
  - For convenience and having to avoid running hyrez locally, there is a rake task which uploads images in `app/javascript/images` to the s3 bucket under `image-assets`, such that dynamic images can work.
    ```
    rake images:upload
    ```
  - Use the above in combination with `bucket_image_url`
  - **Note:** images with the same path will be overwritten.
TEXT
end
