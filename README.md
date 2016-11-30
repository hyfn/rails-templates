# HYFN Rails Templates

Well just template, singular for now.

## app_2016.rb

Rails app with es6 and a bootstrap admin.

### TODO

- [ ] add rspec config file and helpers. maybe run rspec-rails generator?
- [ ] add admin scss, add to assets
- [ ] generate application.rb to autoload services dir, make empty services dir
- [ ] generate development.rb, staging.rb, production.rb based on ones used on prior projects
- [ ] add admin login and routes? add simple_crud and other admin mixins
- [ ] add admin view templates
- [ ] prompt to add heroku remotes
- [ ] trash secrets.yml and other rails junk we don't need
- [ ] add example.env and .env (ignored) and update database.yml
- [ ] maybe add heroku buildpack and update Procfile
- [ ] Puma worker killer?

## admin_2013.rb

For historical interest

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
