source 'https://rubygems.org'
ruby '2.3.1'

gem 'rails', '4.2.5.1'
gem 'pg', '~> 0.15'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

# OWN GEMS#
gem 'annotate' # annotate Rails classes with schema and routes info
gem 'aws-sdk', '< 2.0' # the official AWS SDK for Ruby
gem 'bootstrap-sass', '~> 3.3.6'
gem 'bootstrap-wysihtml5-rails', github: 'nerian/bootstrap-wysihtml5-rails'
gem 'bcrypt' # password hashing algorithmp
gem 'decent_exposure', '3.0.0' # creating declarative interfaces in controllers
gem 'devise' # flexible authentication solution for Rails with Warden.
gem 'font-awesome-rails' # font-awesome font for rails
gem 'html_truncator', '~>0.2' # truncate an HTML string
gem 'i18n-tasks', '~> 0.9.5' # Manage translation for Ruby i18n
gem 'jquery-ui-rails' # jQuery UI for the Rails asset pipeline
gem 'jquery-turbolinks' # fix binded events problem caused by Turbolinks
gem 'lightbox-bootstrap-rails' # lightbox for Bootstrap 3
gem 'mail_form' # send e-mail straight from forms in Rails.
gem 'paperclip', '~> 4.3' # easy file attachment management for ActiveRecord
gem 'pg_search' # PostgreSQL's full text search
gem 'rails_best_practices' # a code metric tool for rails projects
gem 'rails-timeago', '~> 2.0' # helper for time tags
gem 'rolify' # Role management library with resource scoping
gem 'rubocop', require: false # Static code analyzer
gem 'simple_calendar', '~> 2.0' # A wonderfully simple calendar gem for Rails
gem 'simple_form' # forms made easy for Rails!
gem 'slim-rails' # Slim templating.
gem 'sprockets', '~> 3.0' # Rack-based asset packaging system
gem 'stripe', source: 'https://code.stripe.com/' # stripe Ruby bindings
gem 'will_paginate-bootstrap' # bootstrap pagination
gem 'where-or' # Where or function backport from Rails 5 for Rails 4.2
group :assets do
  gem 'jquery-smooth-scroll-rails'
end

group :development do
  gem 'better_errors' # better error page for Rack apps
  gem 'figaro' # Simple Rails app configuration
  gem 'i18n-debug' # i18n-debug translations
  gem 'spring'
  gem 'web-console', '~> 2.0'
  gem 'quiet_assets' # Mutes assets pipeline log messages.
end

group :development, :test do
  # Call 'byebug' anywhere in the occode to stop execution
  # and get a debugger console
  gem 'byebug'
  gem 'capybara' # Simulate your users’ interactions with your application
  gem 'factory_girl_rails' # generating random test data
  gem 'faker' # a library for generating fake data.
  gem 'foreman' # Manage Procfile-based applications
  gem 'rspec-rails', '~> 3.5', '>= 3.5.1' # Use RSpec for specs
  gem 'pry' # An IRB alternative and runtime developer console
end

group :production do
  gem 'rails_12factor' # makes running your Rails app easier.
end

group :test do
  gem 'database_cleaner' # Strategies for cleaning databases in Ruby.
  gem 'shoulda-matchers', require: false # Collection of testing matchers
  gem 'guard-rspec' # Automatically run your specs
  gem 'launchy' # A helper for launching cross-platform applications
end
