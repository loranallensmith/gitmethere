# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitmethere/version'

Gem::Specification.new do |spec|
  spec.name          = "gitmethere"
  spec.version       = Gitmethere::VERSION
  spec.authors       = ["Allen Smith"]
  spec.email         = ["loranallensmith@github.com"]
  spec.summary       = "A tool for demonstrating Git scenarios"
  spec.description   = "This gem is a wrapper for Scott Chacon's ruby-git gem with commands that streamline the process of creating repositories in a given state.  Its primary purpose is for demonstrating common Git scenarios, but it is handy for scripting basic repository operations."
  spec.homepage      = "https://github.com/loranallensmith/gitmethere"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "fakefs", "~> 0.6"

  spec.add_runtime_dependency "git", "~> 1.2"

end
