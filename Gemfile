source 'https://rubygems.org'
ruby '3.1.7'

gem 'rails', '~> 7.0.8', '>= 7.0.8.6'
gem 'puma', '~> 5.0'
gem 'i18n', '>= 1.14', '< 1.15'
gem 'pg', '~> 1.5'
gem 'sass-rails', '~> 6.0'
gem 'uglifier', '>= 4.0.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.11'
gem 'nokogiri', '>= 1.16'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]

# OWN GEMS#
gem 'annotate' # annotate Rails classes with schema and routes info
gem 'aws-sdk-s3', '~> 1.0' # ActiveStorage S3 backend (replaces aws-sdk V1)
gem 'bootstrap-sass', '~> 3.3.6'
gem 'bootstrap-wysihtml5-rails', git: 'https://github.com/nerian/bootstrap-wysihtml5-rails.git'
gem 'bcrypt', '~> 3.1', '>= 3.1.18' # password hashing algorithm
gem 'decent_exposure', '~> 3.0' # creating declarative interfaces in controllers
gem 'devise', '~> 4.9' # flexible authentication solution for Rails with Warden.
gem 'font-awesome-rails', '~> 4.7.0.5' # font-awesome font for rails
gem 'html_truncator', '~>0.2' # truncate an HTML string
gem 'image_processing', '~> 1.12' # ActiveStorage image variants (resize)
gem 'active_storage_validations', '~> 1.0' # content_type/size validators for ActiveStorage
gem 'i18n-tasks', '~> 1.0' # Manage translation for Ruby i18n
gem 'jquery-ui-rails' # jQuery UI for the Rails asset pipeline
gem 'lightbox-bootstrap-rails' # lightbox for Bootstrap 3
gem 'mail', '~> 2.8' # 2.8+ properly declares net-imap/net-smtp as gems (Ruby 3.1+)
gem 'mail_form', '~> 1.10' # send e-mail straight from forms in Rails.
gem 'pg_search', '~> 2.3' # PostgreSQL's full text search
gem 'rails_best_practices' # a code metric tool for rails projects
gem 'rails-timeago', '~> 2.0' # helper for time tags
gem 'rolify', '~> 6.0' # Role management library with resource scoping
gem 'rubocop', require: false # Static code analyzer
gem 'simple_calendar', '~> 2.0' # A wonderfully simple calendar gem for Rails
gem 'simple_form', '~> 5.2' # forms made easy for Rails!
gem 'slim-rails' # Slim templating.
gem 'sprockets', '~> 4.0' # Rack-based asset packaging system
gem 'stripe' # stripe Ruby bindings
gem 'will_paginate-bootstrap' # bootstrap pagination

group :development do
  gem 'better_errors' # better error page for Rack apps
  gem 'figaro' # Simple Rails app configuration
  gem 'i18n-debug' # i18n-debug translations
  gem 'spring'
  gem 'web-console', '~> 4.2'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 11.1'
  gem 'capybara', '~> 3.39' # Simulate your users' interactions with your application
  gem 'factory_bot_rails', '~> 6.2' # generating random test data
  gem 'faker' # a library for generating fake data.
  gem 'foreman' # Manage Procfile-based applications
  gem 'rspec-rails', '~> 6.0' # Use RSpec for specs
  gem 'pry' # An IRB alternative and runtime developer console
end

group :test do
  gem 'database_cleaner' # Strategies for cleaning databases in Ruby.
  gem 'shoulda-matchers', require: false # Collection of testing matchers
  gem 'guard-rspec' # Automatically run your specs
  gem 'launchy' # A helper for launching cross-platform applications
end
