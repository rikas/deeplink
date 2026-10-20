# frozen_string_literal: true

require_relative 'lib/deeplink/version'

Gem::Specification.new do |spec|
  spec.name          = 'deeplink'
  spec.version       = Deeplink::VERSION
  spec.authors       = ['Ricardo Otero']
  spec.email         = ['oterosantos@gmail.com']

  spec.summary       = 'Gem to manage deep links parsing.'
  spec.description   = 'It mitigates the lack of support for mobile deep links on the URI module.'
  spec.homepage      = 'https://github.com/rikas/deeplink'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.2'

  spec.files         = Dir['lib/**/*.rb', 'LICENSE.txt', 'README.md']
  spec.require_paths = ['lib']

  spec.metadata['source_code_uri']       = spec.homepage
  spec.metadata['bug_tracker_uri']       = "#{spec.homepage}/issues"
  spec.metadata['rubygems_mfa_required'] = 'true'
end
