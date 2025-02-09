require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Gocongress
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults '5.2'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # I18n
    # ----

    # https://github.com/rails/rails/commit/813ab76788206ded84cb25e6cd3c259a399ba565
    # http://stackoverflow.com/questions/20361428/rails-i18n-validation-deprecation-warning
    config.i18n.enforce_available_locales = true

    # action_mailer
    # -------------

    config.action_mailer.default_options = {
      from: ENV.fetch('USGC_MAIL_FROM')
    }

    # action_mailer's default_url_options should not be confused with
    # ActionController#default_url_options(). Unlike in ActionController, we
    # can only set static values here, and we can only use what's available
    # during initialization. Specifically, this means that we cannot specify a
    # default year, as we do in ActionController.
    config.action_mailer.default_url_options = { :host => "www.gocongress.org" }

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      :address => "smtp.gmail.com",
      :port => 587,
      :authentication => :plain,
      :user_name => ENV['GMAIL_SMTP_USER'],
      :password => ENV['GMAIL_SMTP_PASSWORD'],
      :enable_starttls_auto => true
    }

    config.enable_dependency_loading = true

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(
      #{Rails.root}/app/exporters
      #{Rails.root}/app/presenters
      #{Rails.root}/lib
      #{Rails.root}/lib/concerns
    )

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Enable the asset pipeline
    config.assets.enabled = true

    # Some libraries have JS, CSS, and images.  It's a hassle
    # to split these libs up, so we keep them whole in a libs dir.
    config.assets.paths << "#{Rails.root}/vendor/assets/libs"

    config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')
    config.assets.precompile << /\.(?:svg|eot|woff|woff2|ttf)$/

    # We don't want Heroku to try to initialize our models during assets:precompile
    # because on Heroku Cedar, the database is not available during slug compilation.
    # http://stackoverflow.com/questions/8622297/heroku-cedar-assetsprecompile-has-beef-with-attr-protected
    # http://guides.rubyonrails.org/asset_pipeline.html
    config.assets.initialize_on_precompile = false

    # action_controller
    # -----------------
    config.action_controller.permit_all_parameters = false
    config.action_controller.action_on_unpermitted_parameters = :raise

    config.active_record.time_zone_aware_types = [:datetime, :time]
  end
end
