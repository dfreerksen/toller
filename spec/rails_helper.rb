# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
  add_filter "spec/"

  add_group "Library", "lib"
end

ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../test/dummy/config/environment", __dir__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require "spec_helper"

require "pry-byebug"
require "rspec/rails"

Dir[File.expand_path("support/**/*.rb", __dir__)].each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
