require "sinatra/named_routes/version"
require 'sinatra/named_routes/router'

require 'sinatra/base'

module Sinatra
  module Namespace
    module SharedMethods
      def named(name, pattern = "/#{name}")
        router.set(pattern, name, get_namespaces)
        pattern
      end

      def get_namespaces
        patterns = [@pattern]
        next_base = base
        while(next_base)
          next_base, pattern = next_base.class_eval {
            [defined?(base) && base, @pattern]
          }
          patterns << pattern if pattern
        end

        node = router

        patterns.reverse.map do |p|
          node = node.children.find {|c| c.content == p}
          node.name
        end
      end
    end
  end

  module NamedRoutes
    def self.registered(app)
      app.set :router, Router.default
    end

    def named(name, pattern = "/#{name}")
      router.set(pattern, name)
      pattern
    end


    module Helpers
      def url_for(*args)
        self.class.router.get(*args)
      end
    end
  end

  helpers Sinatra::NamedRoutes::Helpers
end
