# HYFN Rails Templates

# Rails App 2020

`rails new Skylight -d postgresql -S --skip-listen --skip-coffee -T --webpack=react -p`

## Rails App 2018

### Base App

Rails app with Webpacker, Heroku nginx config.

    rails new testapp -d postgresql --webpack -J -S -T --skip-coffee --skip-turbolinks --webpack=react -m https://raw.github.com/hyfn/rails-templates/master/app_2018.rb

or with `-m ./rails-templates/app_2018.rb` if you've got it locally

### Admin

Admin skeleton with Bootstrap and bootstrap_form. First you make the Base App (see above) and then you run this.

    cd testapp # or whatever you named it
    bin/rails app:template LOCATION=https://raw.github.com/hyfn/rails-templates/master/admin_2018.rb
    bundle install

or with `LOCATION=../rails-templates/admin_2018.rb` if you've got it locally

### Typescript React App

Typescript React starter. First you make the Base App (see above) and then you run this.

    cd testapp # or whatever you named it
    bin/rails app:template LOCATION=https://raw.github.com/hyfn/rails-templates/master/typescript_2018.rb
    bundle install

or with `LOCATION=../rails-templates/typescript_2018.rb` if you've got it locally

### To Do
- [ ] circleCI pg version
- [ ] add coverage tool
- [ ] add other fixture types to tests
- [ ] probably other test stuff - check mxt and xpo
- [ ] update the devise ENV var thing to match xpo. Add it to circleCI config as well
- [ ] scrub all references to SENDGRID
- [ ] move away from the double ENV file thing (instead just gitignore .env)
- [ ] "secret" stuff needs to be update a bit
- [ ] is spring working?
- [ ] assets folder still seems to be making it in there
- [ ] revert my stupid "admin" thing. admin_user is saner
- [ ] make active storage not broken (or remove it)
- [x] update rubocop rules from mxt
- [ ] add `cache:clear` rake task
- [x] `rspec:install` doesn't create `spec_helper.rb`
- [x] add a typescript generator
- [x] `yarn start` is wrong in README
- [ ] make sure the JS build can be uglified
- [ ] Make bootstrap js work
- [x] Better rspec setup
- [x] Clean up package.json - add name and private, etc
- [x] eslint
- [x] js samples
- [x] memcached / memcachier
- [x] circle.yml
- [ ] better webpacker instructions?
- [x] remove hyrez stuff - figure out zany rails storage thing
- [ ] this:

        You need to allow webpack-dev-server host as allowed origin for connect-src.
        This can be done in Rails 5.2+ for development environment in the CSP initializer
        config/initializers/content_security_policy.rb with a snippet like this:
        policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035" if Rails.env.development?
