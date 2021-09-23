# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'deeplink/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.5.0'
  spec.name          = 'deeplink'
  spec.version       = Deeplink::VERSION
  spec.authors       = ['Ricardo Otero']
  spec.email         = ['oterosantos@gmail.com']

  spec.summary       = 'Gem to manage deep links parsing.'
  spec.description   = 'It mitigates the lack of support for mobile deep links on the URI module.'
  spec.homepage      = 'https://github.com/rikas/deeplink'
  spec.license       = 'MIT'

  spec.files         = Dir.glob('{lib}/**/*', File::FNM_DOTMATCH)
  spec.bindir        = 'exe'
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.4.2'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.4.0', '>= 3.4.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-packaging'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'rubocop-rspec'
end
