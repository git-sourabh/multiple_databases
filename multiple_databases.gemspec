# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'multiple_databases/version'

Gem::Specification.new do |spec|
  spec.name          = "multiple_databases"
  spec.version       = MultipleDatabases::VERSION
  spec.authors       = ["Sourabh Upadhyay"]
  spec.email         = ["sourabhupadhyay@hotmail.com"]

  spec.summary       = %q{Use  multiple databases with separate generators and rake commands.}
  spec.description   = %q{You can use mulitple databases in single working enviornment with separate commands and separate folders to manage dbs.}
  spec.homepage      = "https://github.com/git-sourabh/multiple_databases"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  #if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = ""
  #else
  #  raise "RubyGems 2.0 or newer is required to protect against " \
  #    "public gem pushes."
  #end

  spec.files         = Dir['{lib,vendor}/**/*'] - ['Gemfile.lock']
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
