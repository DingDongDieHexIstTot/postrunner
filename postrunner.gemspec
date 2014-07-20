# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'postrunner/version'

Gem::Specification.new do |spec|
  spec.name          = "postrunner"
  spec.version       = PostRunner::VERSION
  spec.authors       = ["Chris Schlaeger"]
  spec.email         = ["chris@linux.com"]
  spec.summary       = %q{Application to manage and analyze Garmin FIT files.}
  spec.description   = %q{This application will allow you to manage and analyze .FIT files as generated by Garmin GPS devices. The application was developed for the Garmin Forerunner 620. Other devices may or may not work. Only devices that expose themselves as USB Mass Storage devices are supported.}
  spec.homepage      = 'https://github.com/scrapper/fit4ruby'
  spec.license       = "GNU GPL version 2"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>=2.0'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
