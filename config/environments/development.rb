Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load


  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  # Action Mailer
  config.action_mailer.default_url_options = { host: ENV['SMTP_DOMAIN'] }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              ENV['SMTP_HOST'],
    port:                 587,
    domain:               ENV['SMTP_DOMAIN'],
    user_name:            ENV['SENDGRID_USERNAME'],
    password:             ENV['SENDGRID_PASSWORD'],
    authentication:       'plain',
    enable_starttls_auto: true  }

  POSTGRES_DATABASE_USERNAME = 'postgres'
  POSTGRES_DATABASE_PASSWORD = 'admin$123'
  POSTGRES_DATABASE_PORT = 5432
  POSTGRES_DATABASE_HOST = '127.0.0.1'

  # RDS_DB_NAME = 'cowtribe-api-rails-test'
  # RDS_USERNAME = 'shepherd'
  # RDS_PASSWORD = 'shepherd$1234'
  # RDS_HOSTNAME = 'shepherd-api-test-instance'
  # RDS_PORT = '5432'

  SECRET_KEY_BASE = '6d6d9c20403f6d3f05d98930b99fb9120105dc404b2e0bcc65ae71343aec2bb59c2e6f17bba7f15b3e911da90cc48778e7376e54e20fef79db50d7d6ae1c71c9'
end
