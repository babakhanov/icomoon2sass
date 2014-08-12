# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'icomoon2sass/version'

Gem::Specification.new do |spec|
  spec.name          = 'icomoon2sass'
  spec.version       = Icomoon2Sass::VERSION
  spec.authors       = ['Jed Foster']
  spec.email         = ['jed@jedfoster.com']
  spec.description   = %q{Utility for using Icomoon icon sets in Sass projects}
  spec.summary       = %q{Command line utility that extracts fonts and codepoints from an Icomoon .zip file and generates a Sass file with variables and placholders.}
  spec.homepage      = 'https://github.com/jedfoster/icomoon2sass'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*']

  spec.executables   = 'icomoon2sass'
  spec.require_paths = ['lib']

  #spec.add_development_dependency 'rake'
  spec.add_dependency('thor')
  spec.add_dependency('rubyzip')
  spec.add_dependency('sass', '>= 3.2.0')
end

