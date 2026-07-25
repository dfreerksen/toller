# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "toller/version"

Gem::Specification.new do |spec|
  spec.name        = "toller"
  spec.version     = Toller::VERSION
  spec.authors     = ["David Freerksen"]
  spec.email       = ["dfreerksen@gmail.com"]
  spec.homepage    = "https://github.com/dfreerksen/toller"
  spec.summary     = "Summary of Toller."
  spec.description = "Description of Toller."
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 3.0"

  spec.metadata = {
    "rubygems_mfa_required" => "true",
    "bug_tracker_uri" => "https://github.com/dfreerksen/toller/issues",
    "documentation_uri" => "https://www.rubydoc.info/github/dfreerksen/toller/master",
    "homepage_uri" => "https://github.com/dfreerksen/toller",
    "source_code_uri" => "https://github.com/dfreerksen/toller",
    "wiki_uri" => "https://github.com/dfreerksen/toller/wiki"
  }

  spec.files = Dir["{lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 5.2"
end
