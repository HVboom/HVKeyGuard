require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HVKeyGuard
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Use UUIDs instead of integer as primary keys
    # config.generators do |g|
    #   g.orm :active_record, primary_key_type: :uuid
    # end

    # I18n prefering German
    I18n.available_locales = [:en, :de]
    I18n.default_locale = :de

    # Single DB connection
    ### config.active_record.legacy_connection_handling = false

    # Allow access from and to all application specific domains
    # see https://guides.rubyonrails.org/configuring.html#actiondispatch-hostauthorization
    #   production:  hvkeyguard.hvboom.org
    #   development: hvkeyguard.demo.hvboom.org
    config.hosts = [ %r{hvkeyguard\.([^\.]+\.)?hvboom\.org} ]
  end
end
