# frozen_string_literal: true

appraise "rails-8-1" do
  gem "rails", "~> 8.1.0"
end

appraise "rails-8-0" do
  gem "rails", "~> 8.0.0"
end

appraise "rails-7-2" do
  gem "rails", "~> 7.2.0"
end

appraise "rails-7-1" do
  gem "rails", "~> 7.1.0"

  gem "rspec-rails", "~> 7.1.1", require: false
end

appraise "rails-7-0" do
  gem "rails", "~> 7.0.0"

  gem "rspec-rails", "~> 7.1.1", require: false

  # activerecord <7.1"s sqlite3_adapter.rb hardcodes `gem "sqlite3", "~> 1.4"`
  gem "sqlite3", "~> 1.4"
end

appraise "rails-6-1" do
  gem "rails", "~> 6.1.0"

  gem "rspec-rails", "~> 6.1.5", require: false

  # activerecord <7.1"s sqlite3_adapter.rb hardcodes `gem "sqlite3", "~> 1.4"`
  gem "sqlite3", "~> 1.4"

  # Ruby >=3.4 no longer ships these as default gems; Rails 6.1 needs them at boot
  gem "bigdecimal"
  gem "mutex_m"
  gem "logger"
end

appraise "rails-6-0" do
  gem "rails", "~> 6.0.0"

  gem "rspec-rails", "~> 5.1.2", require: false

  # activerecord <7.1"s sqlite3_adapter.rb hardcodes `gem "sqlite3", "~> 1.4"`
  gem "sqlite3", "~> 1.4"

  # Ruby >=3.4 no longer ships these as default gems; Rails 6.0 needs them at boot
  gem "bigdecimal"
  gem "mutex_m"
  gem "drb"
  gem "logger"
end
