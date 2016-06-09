# Copyright 2011-2013, The Trustees of Indiana University and Northwestern
#   University.  Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
# 
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software distributed 
#   under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#   CONDITIONS OF ANY KIND, either express or implied. See the License for the 
#   specific language governing permissions and limitations under the License.
# ---  END LICENSE_HEADER BLOCK  ---

Avalon::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  config.log_level = :debug

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true 

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 2.0
 
  # Do not compress assets
  config.assets.compress = true

  # Expands the lines which load the assets
  config.assets.debug = true

  # Keep only five logs and rotate them every 5 MB
  #config.logger = Logger.new(Rails.root.join("log", 
  #  Rails.env + ".log"), 
  #  10, 10*(2**20))
  
  # Configure logging to provide a meaningful context such as the 
  # timestamp and log level. This only works under Rails 3.2.x so if you
  # are using an older version be sure to comment it out
  config.log_tags = ['AVALON',
    :remote_ip,
    Proc.new { Time.now.strftime('%Y.%m.%d %H:%M:%S.%L')}]
   
  config.action_mailer.delivery_method = :letter_opener if ENV['LETTER_OPENER']

  #config.middleware.insert_before Rails::Rack::Logger, DisableAssetsLogger
end
