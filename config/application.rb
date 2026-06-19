require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Aquapark
  # main initializers for application, as autoload paths.
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those
    # specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record
    # auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names.
    # Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from
    # config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales',
                                                 '*.{rb,yml}').to_s]
    config.i18n.default_locale = :pl
    config.beginning_of_week = :monday
    # Disable belongs_to required by default for incremental Rails 5 migration.
    # TODO Stage 3: remove this and add optional: true where needed.
    config.active_record.belongs_to_required_by_default = false

    # Autoload files under /lib
    config.autoload_paths << "#{Rails.root}/lib"

    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: true,
                       request_specs: true
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end
  end
end
