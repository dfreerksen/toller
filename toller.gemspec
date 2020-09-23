# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'toller/version'

Gem::Specification.new do |spec|
  spec.name        = 'toller'
  spec.version     = Toller::VERSION
  spec.authors     = ['David Freerksen']
  spec.email       = ['dfreerksen@gmail.com']
  spec.homepage    = 'https://github.com/dfreerksen/toller'
  spec.summary     = 'Summary of Toller.'
  spec.description = 'Description of Toller.'
  spec.license     = 'MIT'

  spec.required_ruby_version = '>= 2.5.8'

  spec.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'rails', '>= 5.0'

  spec.add_development_dependency 'appraisal', '~> 2.3.0'
end
