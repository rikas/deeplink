# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'deeplink/version'

Gem::Specification.new do |spec|
  spec.name          = 'deeplink'
  spec.version       = Deeplink::VERSION
  spec.authors       = ['Ricardo Otero']
  spec.email         = ['oterosantos@gmail.com']

  spec.summary       = 'Gem to manage deep links parsing.'
  spec.description   = 'It mitigates the lack of support for mobile deep links on the URI module.'
  spec.homepage      = 'https://github.com/rikas/deeplink'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4.0', '>= 3.4.0'
  spec.add_development_dependency 'pry', '~> 0.10.3'
end
