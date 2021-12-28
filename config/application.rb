require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Stackoverflow
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    #config.autoload_paths += [config.root.join('app')]

    config.active_storage.replace_on_assign_to_many = false
    #Bundler.require(*Rails.groups)
    
    config.active_job.queue_adapter = :sidekiq

    config.cache_store = :redis_cache_store #, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes }
  end
end
