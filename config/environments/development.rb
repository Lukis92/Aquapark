Rails.application.configure do
  config.enable_reloading = true
  config.eager_load = false

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.action_mailer.raise_delivery_errors = true

  config.active_support.report_deprecations = true

  config.active_record.migration_error = :page_load

  config.assets.debug = true
  config.assets.digest = true
  config.assets.compile = true
  config.assets.precompile += %w( *.js *.css *.css.erb )
  config.assets.raise_runtime_errors = true

  config.public_file_server.enabled = true

  config.active_storage.service = :local

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  # Paperclip Heroku S3.
  config.paperclip_defaults = {
    storage: :s3,
    url: ':s3_domain_url',
    path: '/:class/:attachment/:id_partition/:style/:filename',
    s3_credentials: {
      bucket: ENV['S3_BUCKET_NAME'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    }
  }

  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :smtp

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
