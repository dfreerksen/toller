# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

group :development, :test do
  gem 'sqlite3', '~> 1.4.2'

  gem 'rubocop', '~> 0.91.0', require: false
  gem 'rubocop-rspec', '~> 1.43.2', require: false
end

group :test do
  gem 'pry-byebug', '~> 3.9.0', require: false
  gem 'rspec-rails', '~> 4.0.1', require: false
  gem 'simplecov', '~> 0.19.0', require: false
end
