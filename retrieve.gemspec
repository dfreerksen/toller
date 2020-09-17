# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'retrieve/version'

Gem::Specification.new do |spec|
  spec.name        = 'retrieve'
  spec.version     = Retrieve::VERSION
  spec.authors     = ['David Freerksen']
  spec.email       = ['dfreerksen@gmail.com']
  spec.homepage    = 'https://github.com/dfreerksen/retrieve'
  spec.summary     = 'Summary of Retrieve.'
  spec.description = 'Description of Retrieve.'
  spec.license     = 'MIT'

  spec.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'rails', '~> 6.0.3', '>= 6.0.3.2'

  spec.add_development_dependency 'sqlite3'
end
