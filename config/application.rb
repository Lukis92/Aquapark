require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Aquapark
  class Application < Rails::Application
    # Load Rails 7.0 defaults. New defaults introduced since Rails 5.2 are
    # activated incrementally here; any that break the app are overridden below.
    config.load_defaults 7.0

    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :pl
    config.beginning_of_week = :monday

    # Keep belongs_to optional until all associations are audited for nullability.
    # TODO: add `optional: true` where FK is nullable, then remove this override.
    config.active_record.belongs_to_required_by_default = false

    config.active_storage.variant_processor = :mini_magick

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
