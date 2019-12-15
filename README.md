# HYFN Rails Templates

## Rails App 2020

### Base App

    rails new skylight -d postgresql -S -T --skip-coffee --skip-turbolinks --webpack=react -m ./rails-templates/app_2020.rb

### Typescript React App

Typescript React starter. First you make the Base App (see above) and then you run this.

    cd testapp # or whatever you named it
    bin/rails app:template LOCATION=https://raw.github.com/hyfn/rails-templates/master/typescript_2018.rb
    bundle install

or with `LOCATION=../rails-templates/typescript_2020.rb` if you've got it locally


### To Do
- [x] circleCI pg version
- [ ] add coverage tool
- [ ] add other fixture types to tests
- [ ] probably other test stuff - check mxt and xpo
- [ ] update the devise ENV var thing to match xpo. Add it to circleCI config as well
- [x] scrub all references to SENDGRID
- [x] ~~move away from the double ENV file thing (instead just gitignore .env)~~
- [x] "secret" stuff needs to be update a bit
- [ ] is spring working?
- [x] assets folder still seems to be making it in there
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
