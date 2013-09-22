# -*- encoding: utf-8 -*-
require File.expand_path('../lib/regularity/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'regularity'
  s.date          = '2013-09-13'
  s.summary       = "A friendly regular expression builder for Ruby"
  s.description = %q{
    Regularity provides a flexible syntax for constructing regular
    expressions by chaining Ruby method calls instead of deciphering
    cryptic syntax.
  }.gsub(/\s+/, ' ')
  s.authors     = ['Andrew Berls']
  s.email       = 'andrew.berls@gmail.com'
  s.homepage    = 'https://github.com/andrewberls/regularity'
  s.license     = 'MIT'

  s.files         = Dir['lib/**/*']
  s.require_paths = ['lib']
  s.version       = Regularity::VERSION

  s.add_development_dependency 'rspec'
end
