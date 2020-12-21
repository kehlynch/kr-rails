# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Kr
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.sass.preferred_syntax = :sass
    config.sass.line_comments = false
    config.sass.cache = false

    # turn off channel logging
    ActionCable.server.config.logger = Logger.new(nil)

    # excluded_routes = ->(env) { !env["PATH_INFO"].match(%r{^/api}) }
    config.middleware.use OliveBranch::Middleware,
      inflection:       "camel",
      # exclude_params:   excluded_routes,
      # exclude_response: excluded_routes

    ActiveModelSerializers.config.adapter = :json
    # ActiveModelSerializers.config.key_transform = :camel_lower
    ActiveModelSerializers.config.key_transform = :camel_lower
    ActiveModelSerializers.config.default_includes = "**"
    ActiveModel::Serializer.config.key_transform = :camel_lower
    ActiveModel::Serializer.config.default_includes = "**"
  end
end
