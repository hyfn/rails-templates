# #{app_title}

TODO:
- Project overview
- Staging and production URLs

## Up and Running

### First Time

1. Get Ruby 2.4.1 installed
  - `rvm install 2.4.1` if you have [RVM](https://rvm.io/)
  - `brew install ruby` if you want to use homebrew
2. Install some dependencies
  - `brew install postgres`
  - `brew install yarn`
  - `brew services start postgres`
  - `gem install bundler foreman`
3. Fill in the `.env.local` file with real values. These might come from Heroku or one of your fellow developers.
4. Make sure you have the most current version of X-Code Command Line Tools
  - `xcode-select --install`
5. Install gems
  - Ruby: `bundle install`
  - Javascript: `yarn install`
6. Get your app database set up
  - `bin/rails db:create db:migrate db:seed`

## Running the App Locally

1. Each time you pull
  - `bundle install`
  - `yarn install`
  - `bin/rails db:migrate`
2. Run it
  - In two terminal tabs:
    - `bin/rails s` (in one terminal tab)
    - `yarn start` (in another terminal tab)
  - In one terminal tab:
    - `foreman start -f Procfile.dev`
  - `bin/rails s`
  - Navigate to http://localhost:3000/

## Tasks

### Add/Remove Frontend Depencies

- Add: `yarn add xyz`
- Remove: `yarn remove xyz`

### Add/Remove Node Depencies

- Add: `yarn add xyz-loader --dev`
- Remove: `yarn remove xyz-loader --dev`

### Linting

Check and fix style errors and such

**Ruby**

    bin/rubocop -D
    bin/rubocop -D -a # autocorrect

**Javascript**

    yarn run eslint
    yarn run fix # autocorrect

### Tests

  Ruby: `bin/rspec`

## Deployment

### Prep

_TODO: Add real values_

- Add staging remote: `heroku git:remote -r staging -a <app_name>`
- Add production remote: `heroku git:remote -r production -a <app_name>`

### Deploy

  - Staging: `git push staging develop:master` (where `develop` is the branch you want to deploy)
  - Production: `git push production master`

### Other Useful Heroku Stuff

  - Run a console: `heroku run rails c -r staging`
  - Run a shell: `heroku run bash -r staging`
  - Tail the logs: `heroku logs -t -r staging`
  - Launch the site: `heroku open -r staging`

## Syncing Data

_TODO: Fill me in_

### Frontend Setup

- Javascript is handled through webpack (via [Webpacker](https://github.com/rails/webpacker)). It lives in `app/javascript`.
- package.json is located in `package.json`. Use `yarn` to do yarn/npm things.
- Webpack config is in `config/webpack` directory. Entry points are in `app/javascript/packs`.
