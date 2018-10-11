$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "uuid_parameter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "uuid_parameter"
  s.version     = UUIDParameter::VERSION
  s.authors     = ["hellekin"]
  s.email       = ["hellekin@cepheide.org"]
  s.homepage    = "https://gitlab.com/incommon.cc/uuid_parameter"
  s.summary     = "Adds a UUID to an ActiveRecord model."
  s.description = "UUIDParameter handles a :uuid column and validation for any model."
  s.license     = "MIT"

  s.files = Dir["{config,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.1"

  s.add_development_dependency "pry"
  s.add_development_dependency "rspec", "~> 3.7"
  s.add_development_dependency "sqlite3"
end
