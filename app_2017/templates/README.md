# #{app_title}

TODO:
- Project overview
- Staging and production URLs

## Up and Running

### First Time

1. Get Ruby 2.3.1 installed
  - `rvm install 2.3.1` if you have [RVM](https://rvm.io/)
  - `brew install ruby` if you want to use homebrew
2. Install some dependencies
  - `brew install postgres`
  - `brew install imagemagick`
  - `brew services start postgres`
3. Fill in the `.env` file with real values. These might come from Heroku or one of your fellow developers.
4. Make sure you have the most current version of X-Code Command Line Tools
  - `xcode-select --install`
5. Install gems
  - `bundle install`
6. Get your app database set up
  - `bin/rake db:create db:migrate db:seed

## Running the App Locally

1. Each time you pull
  - `bundle install`
  - `rake db:migrate`
2. Run it
  - `bin/rails s`
  - Navigate to http://localhost:3000/

## Tasks

_TODO: Fill me in_

## Syncing Data

_TODO: Fill me in_

## Structure / Guidelines

- Indent with soft tabs (two spaces.)
- Frontend files are in the `app/assets` directory.
- Within those directories, organize files however you like.
- You can use es6 and `import` / `export` in js files.
- Add third-party dependencies to the Gemfile and `application.js`. They will generally be included in the global JS scope.
- You can use `@import` in scss files.
- HTML files are stored in `app/views`.
- They use erb, see: http://guides.rubyonrails.org/layouts_and_rendering.html
- Don't hardcode asset URLs anywhere. Instead use asset helpers, like this:
    - HTML: `<%= image_tag 'image.png', alt: "image" %>` or `<img src="<%= image_path('image.png') %>" alt="image">`
    - SCSS: `background-image: image-url('image.png');`
