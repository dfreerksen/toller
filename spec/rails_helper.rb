# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
  group "Libraries", "lib"
  skip "/spec/"
  skip "/test/"
end

ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../test/dummy/config/environment", __dir__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

# `ActiveRecord::Migration.maintain_test_schema!` loads/checks the schema via a
# temporary connection pool, which is useless for an in-memory sqlite3 database
# (each new connection gets its own separate, empty database). Load the schema
# directly onto the connection this process actually uses instead.
load Rails.root.join("db/schema.rb")

require "spec_helper"

require "pry-byebug"
require "rspec/rails"

Dir[File.expand_path("support/**/*.rb", __dir__)].each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
