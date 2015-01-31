# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'refinements_file/version'

Gem::Specification.new do |spec|
  spec.name          = "refinements_file"
  spec.version       = RefinementsFile::VERSION
  spec.authors       = ["Pablo Herrero"]
  spec.email         = ["pablodherrero@gmail.com"]
  spec.summary       = %q{Adds support for refinement definition files}
  spec.description   = %q{Enrichs Ruby with refinement definition files allowing to easily reuse the same refinements across multiple files.}
  spec.homepage      = "https://github.com/pabloh/refinements_file"
  spec.license       = "MIT"
  spec.required_ruby_version = '>= 2.1'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-stack_explorer"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
end
