source 'http://rubygems.org'
ruby '2.2.5'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'
gem 'rails-i18n','~> 4.0.0'
gem 'rails_12factor'


gem 'pagseguro-oficial', '~> 2.5.0'
# Use postgresql as the database for Active Record
gem 'mysql2', '~> 0.3.18'

# Use Devise for user authentication
gem 'devise', '~> 3.4.1'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.1'
# A simple and lightweight mixin library for Sass
gem 'bourbon', '~>4.2.3'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.1'

# Add Foundation Here
gem 'compass-rails', '~> 2.0.4' # you need this or you get an err
gem 'foundation-rails', '~>5.5.2.1'

gem 'nested_form'
gem 'simple_form'

gem 'money-rails'

gem 'therubyracer', :group => :assets

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'quiet_assets'
  gem 'pry-meta'
  gem 'thin'
  gem 'foreman'
  # gem 'capistrano','~> 2.15.4'

  gem 'capistrano', '~> 3.2.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rails', '~> 1.1.3'
  gem 'capistrano-rails-collection'
  gem 'capistrano3-unicorn'

  # This plugin helps you setup and debug ssh-agent forwarding for Capistrano deployment.
  gem 'capistrano-ssh-doctor', '~> 1.0'

  # Skips asset compilation if none of the assets were changed since last release.
  # gem 'capistrano-faster-assets', '~> 1.0'

  # Add this if you're using rbenv
  gem 'capistrano-rbenv', github: 'capistrano/rbenv'
  gem 'better_errors'
  gem 'binding_of_caller'
end

# Use unicorn as the app server
group :production do
  gem 'puma'
  gem 'pg'
  # gem 'passenger'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use debugger
# gem 'debugger', group: [:development, :test]
gem 'open4'
