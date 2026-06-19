Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  config.active_storage.service = :amazon

  config.assets.compile = true # Keep compile on for Heroku.
  config.assets.precompile += %w( *.js *.css *.css.erb )
  config.assets.digest = true

  config.log_level = :debug

  config.i18n.fallbacks = true

  config.active_support.report_deprecations = false
  config.active_support.disallowed_deprecation = :log
  config.active_support.disallowed_deprecation_warnings = []

  config.log_formatter = ::Logger::Formatter.new

  config.active_record.dump_schema_after_migration = false

  # Paperclip Heroku S3.
  config.paperclip_defaults = {
    storage: :s3,
    url: ':s3_domain_url',
    path: '/:class/:attachment/:id_partition/:style/:filename',
    s3_credentials: {
      bucket: ENV['AWS_BUCKET_NAME'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    }
  }

  config.action_mailer
        .default_url_options = { host: 'aquapark-s9434.herokuapp.com' }

  Rails.application.routes
       .default_url_options[:host] = 'aquapark-s9434.herokuapp.com'

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default charset: 'utf-8'

  config.action_mailer.smtp_settings = {
    address: 'smtp.gmail.com',
    port: 587,
    domain: ENV['GMAIL_DOMAIN'],
    authentication: 'plain',
    enable_starttls_auto: true,
    user_name: ENV['GMAIL_USERNAME'],
    password: ENV['GMAIL_PASSWORD']
  }
end
