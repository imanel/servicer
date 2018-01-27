# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'servicer/version'

Gem::Specification.new do |s|
  s.name        = 'servicer'
  s.version     = Servicer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Bernard Potocki']
  s.email       = ['bernard.potocki@imanel.org']
  s.homepage    = 'http://github.com/imanel/servicer'
  s.summary     = 'Simple Service Object builder.'
  s.description = 'Simple Service Object builder.'
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.3'
end
