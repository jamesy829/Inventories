source 'https://rubygems.org'

ruby "2.1.0"

#ruby=ruby-2.1.0
#ruby-gemset=Inventories

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.3'

# Use passenger for web service layer
gem 'passenger'

# Use postgreSQL as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
gem 'bootstrap-sass'

# Use New Relic for server monitoring
gem 'newrelic_rpm'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# replace erb with slim template
gem 'slim'
gem 'slim-rails'
gem 'html2slim'
gem 'nokogiri'

# Add devise for authentication system
gem 'devise'

# Add foreign key
gem 'foreigner'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# This gem integrates the Twitter Bootstrap pagination component with the will_paginate pagination gem.
gem 'will_paginate-bootstrap', git: 'https://github.com/majorvin/will_paginate-bootstrap.git'

# Use faker to generate fake data
gem 'faker'

# activerecord-import is a library for bulk inserting data using ActiveRecord.
gem 'activerecord-import'

# Progress bar for reporting status
gem 'ruby-progressbar'

# Unit test libraries
group :development, :test do
  # Use spork to boost rspec speec
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'spork-rails'
  gem 'guard-spork'
  gem 'childprocess'

  # Use rspec for test framework
  gem 'rspec-rails'

  # Use pry for easier debugging
  gem 'pry'

  # Bootstrap
  gem 'rails_layout'

  gem 'factory_girl_rails'
end

group :test do
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'nyan-cat-formatter'
  gem 'capybara'
  gem 'selenium-webdriver'

  # Fix cloudbees issues with execjs
  gem 'therubyracer'
  gem 'execjs'

  # Test Coverage
  gem 'simplecov', require: false
  gem 'coveralls', require: false
end

group :production do
  # Serve static assets and logging on Heroku
  gem 'rails_12factor'

  gem 'capistrano', '~> 3.1'
  # rails specific capistrano funcitons
  gem 'capistrano-rails', '~> 1.1'
  # integrate bundler with capistrano
  gem 'capistrano-bundler', '~> 1.1.2'
  # integrate rvm with capistrano
  gem 'capistrano-rvm'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
