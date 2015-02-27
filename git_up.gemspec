# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git_up/version'

Gem::Specification.new do |spec|
  spec.name          = "git_up"
  spec.version       = GitUp::VERSION
  spec.authors       = ["Pete Kinnecom"]
  spec.email         = ["pete.kinnecom@appfolio.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency('thor', ['>= 0.19', '< 1.0'])
  spec.add_dependency('work_queue', ['>= 2.5.3', '< 3.0'])
end
