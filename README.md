# HYFN Rails Templates

## app_2016.rb

Rails app with es6, Bootstrap admin, Heroku nginx config

Run like this:

    rails new APP_NAME -d postgresql -J -C --skip-listen --skip-turbolinks -T -m  https://raw.github.com/hyfn/rails-templates/master/app_2016.rb

Or for local:

    rails new APP_NAME -d postgresql -J -C --skip-listen --skip-turbolinks -T -m ./rails-templates/app_2016.rb

### Features

- Good frontend defaults
  - [x] ES6, sprockets, almond, uglifier, autoprefixer, normalize, JQuery, bower
  - [ ] Sets up some amd boilerplate for almond
- Adds monitoring (New Relic, Sentry)
  - [x] New Relic config
- Testing setup
  - [x] Adds rspec and generates config
  - [x] Adds fabrication, webmock, timecop
  - [x] Prettier test runner
  - [ ] Sets up common helpers and rspec defaults
- Development Setup
  - [x] Better dev config
  - [x] Sets up pry, spring, rubocop, bullet, bundler audit
  - [x] Rubocop config
  - [x] Add .env and example.env
  - [x] Removes secrets.yml, use ENV var
  - [x] Simplify database.yml, use ENV vars
- Sets up admin skeleton
  - [x] Bootstrap, haml, kaminari
  - [x] Admin SCSS and JS
  - [x] Admin sessions controller, routes, views
  - [x] Admin controller mixins
  - [ ] Admin layout, menus, dashboard?
- Heroku deployment
  - [x] Puma config with threads/workers set via ENV
  - [x] Puma worker killer
  - [x] Heroku nginx config, Procfile, Puma config updates
  - [x] Prompt to associate with Heroku apps, adds buildpacks
  - [x] Generates production/staging configs

## admin_2013.rb

_Strictly of historical interest._

Build a rails app from it like this:

`rails new project-name -T -m https://raw.github.com/hyfn/rails-templates/master/hyfn-admin-heroku.rb`

The app should be available at http://project-name.dev if you ran the pow thing

### Features

- AR enhancements: foreigner, squeel, ransack
- Monitoring: newrelic, airbrake
- Admin skeleton with: inherited_resources, simple_form, carrierwave, haml, bootstrap, compass
- rspec, factory_girl, spork, shoulda, webmock for testing
- Generates an admin login page and dashboard


### TODO

Fix database.yml stuff
