# -*- encoding: utf-8 -*-
require File.expand_path('../lib/debox/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Eloy Gomez"]
  gem.email         = ["eloy@indeos.es"]
  gem.description   = "CLI for debox"
  gem.summary       = "Debox is a deploy manager"
  gem.homepage      = "https://github.com/harlock/debox"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "debox"
  gem.require_paths = ["lib"]
  gem.version       = Debox::VERSION

  gem.add_runtime_dependency 'json'
  gem.add_runtime_dependency 'netrc'
  gem.add_runtime_dependency 'highline'
  gem.add_runtime_dependency 'eventmachine'
  gem.add_runtime_dependency 'em-eventsource'
end
