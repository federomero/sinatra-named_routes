require 'tree'
require 'cgi'

module Sinatra
  module NamedRoutes
    module Exceptions
      class NoRouteForName < Exception; end
      class RouteNameTaken < Exception; end
    end
    class Router < Tree::TreeNode
      def self.default
        @@default ||= Router.new(:root, '')
      end

      def traverse path
        base = self
        path.each do |step|
          base = base[step]
          yield(base) if block_given?
        end
        base
      end

      def set pattern, name, path = []
        node = traverse(path)
        raise Sinatra::NamedRoutes::Exceptions::RouteNameTaken if node[name] && node[name].content != pattern
        node << Tree::TreeNode.new(name, pattern) unless node[name]
      end

      def get *args
        options = args.last.is_a?(::Hash) ? args.pop : {}
        path = ''
        traverse(args) do |node|
          begin
            path += node.content
          rescue
            raise Sinatra::NamedRoutes::Exceptions::NoRouteForName, "No route for name #{args.inspect}"
          end
        end

        query = []
        options.each do |k, v|
          regex = /(:#{k})/
            if path =~ regex
              path.gsub!(regex, CGI.escape(v.to_s))
            else
              query << "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"
            end
        end

        path += '?'+query.join("&") unless query.empty?

        path
      end
    end
  end
end
