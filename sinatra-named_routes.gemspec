# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sinatra/named_routes/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Federico Romero"]
  gem.email         = ["federomero@gmail.com"]
  gem.description   = %q{Sinatra extension that allows you to use name your routes}
  gem.summary       = %q{Sinatra named routes}
  gem.homepage      = "https://github.com/federomero/sinatra-named_routes"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "sinatra-named_routes"
  gem.require_paths = ["lib"]
  gem.version       = Sinatra::NamedRoutes::VERSION

  gem.add_dependency 'sinatra'
  gem.add_dependency 'tree'
  gem.add_development_dependency 'sinatra-contrib'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest', '3.2.0'
end
