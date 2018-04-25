require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

require "sidekiq/testing"

require 'simplecov'

SimpleCov.start

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end

RSpec::Sidekiq.configure do |config|
  config.clear_all_enqueued_jobs = true

  config.enable_terminal_colours = true

  config.warn_when_jobs_not_processed_by_sidekiq = true
end
