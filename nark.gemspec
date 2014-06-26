# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nark/version'

Gem::Specification.new do |spec|
  spec.name          = 'nark'
  spec.version       = Nark::VERSION
  spec.authors       = ['Mark Ryall']
  spec.email         = ['mark@ryall.name']
  spec.summary       = 'abstraction layer for publishing analytics events.'
  spec.homepage      = 'https://github.com/everydayhero/nark'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'

  spec.add_dependency 'keen', '~> 0.8'
end
