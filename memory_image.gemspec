# coding: utf-8
config = File.expand_path('../config', __FILE__)
require "#{config}/version"

Gem::Specification.new do |spec|
  spec.name          = "memory_image"
  spec.version       = MemoryImage::VERSION
  spec.authors       = ["Stephen McGinty"]
  spec.email         = ["r49409@freescale.com"]
  spec.summary       = "Provides a standard API for consuming memory image files in any format e.g. s-record, hex"
  spec.homepage      = "http://rgen.freescale.net/memory_image"

  spec.required_ruby_version     = '>= 1.9.3'
  spec.required_rubygems_version = '>= 1.8.11'

  # Only the files that are hit by these wildcards will be included in the
  # packaged gem, the default should hit everything in most cases but this will
  # need to be added to if you have any custom directories
  spec.files         = Dir["lib/**/*.rb", "templates/**/*", "config/**/*.rb",
                           "bin/*", "lib/tasks/**/*.rake", "pattern/**/*.rb",
                           "program/**/*.rb"
                          ]
  spec.executables   = []
  spec.require_paths = ["lib"]

  # Add any gems that your plugin needs to run within a host application
  spec.add_runtime_dependency "rgen_core", ">= 2.5.0.pre27"

  # Add any gems that your plugin needs for its development environment only
  spec.add_development_dependency "doc_helpers", ">= 1.7.2"
end
