# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'card_decks/version'

Gem::Specification.new do |spec|
  spec.name          = "card_decks"
  spec.version       = CardDecks::VERSION
  spec.authors       = ["matt"]
  spec.email         = ["mgwidmann@gmail.com"]
  spec.summary       = %q{Deck of cards API for implementing digital card games.}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.99" # Need to upgrade to 3.0 when I learn the API
end
