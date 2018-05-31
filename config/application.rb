require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HVKeyGuard
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Use UUIDs instead of integer as primary keys
    # config.generators do |g|
    #   g.orm :active_record, primary_key_type: :uuid
    # end

    # I18n prefering German
    I18n.available_locales = [:en, :de]
    I18n.default_locale = :de
  end
end
