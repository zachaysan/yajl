# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yajl/version'

Gem::Specification.new do |spec|
  spec.name          = "yajl"
  spec.version       = Yajl::VERSION
  spec.authors       = ["Zach Aysan"]
  spec.email         = ["zachaysan@gmail.com"]

  spec.summary       = %q{ Yet Another JSON Logger }
  spec.description   = %q{ Rather than streaming logs through a UDP connection this
                           logger favors a simplier method: store things locally and
                           retrieve them when your servers are not busy. }
  spec.homepage      = "https://github.com/zachaysan/yajl"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"

end
