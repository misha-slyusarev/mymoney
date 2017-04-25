# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mymoney/version'

Gem::Specification.new do |spec|
  spec.name          = "mymoney"
  spec.version       = Mymoney::VERSION
  spec.authors       = ["Misha Slyusarev"]
  spec.email         = ["mik3weider@gmail.com"]

  spec.summary       = %q{Simple Money class}
  spec.description   = %q{A set of simple operations to work with money and convertion}
  spec.homepage      = "https://github.com/misha-slyusarev/mymoney"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
