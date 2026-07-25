# frozen_string_literal: true

# Ruby 3.4+ ships a `logger` gem (1.6+) that no longer implicitly defines the
# top-level `Logger` constant the way older Rails versions (6.0/6.1) expect
# when they reference it from `ActiveSupport::LoggerThreadSafeLevel`. Require
# it explicitly before Rails loads so those appraisals still boot.
require "logger"

# Set up gems listed in the Gemfile.
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../../Gemfile", __dir__)

require "bundler/setup" if File.exist?(ENV["BUNDLE_GEMFILE"])
$LOAD_PATH.unshift File.expand_path("../../../lib", __dir__)
