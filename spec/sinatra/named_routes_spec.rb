ENV['RACK_ENV'] = 'test'
require 'sinatra/base'
require 'sinatra/namespace'
require 'minitest/autorun'
require 'rack/test'

require_relative '../../lib/sinatra/named_routes'

Sinatra::Base.set :environment, :test


class MockApp < Sinatra::Base
  register Sinatra::Namespace
  register Sinatra::NamedRoutes
  helpers Sinatra::NamedRoutes::Helpers

  def self.router
    @router ||= Sinatra::NamedRoutes::Router.new(:root, nil)
  end
end

module Rack::Test::Methods
  def mock_app(base=MockApp, &block)
    @app = Sinatra.new(base, &block)
  end
  def app
    @app
  end
end

describe 'NamedRoutes' do
  include Rack::Test::Methods

  it 'should handle the root path' do
    mock_app{ get(named(:root, '/')) { "hi" }}
    get "/"

    last_response.status.must_equal 200
    last_response.body.must_equal "hi"
  end

  describe 'with a literal path' do
    it 'should find the route correctly' do
      mock_app{ get(named(:some_name, '/some_path')) { "hi" }}
      get "/some_path"

      last_response.status.must_equal 200
      last_response.body.must_equal "hi"
    end

    it 'should generate the route correctly' do
      mock_app{ get(named(:some_name, '/some_path')) { url_for(:some_name) }}

      get "/some_path"

      last_response.status.must_equal 200
      last_response.body.must_equal "/some_path"

    end

  end

  describe 'with a params in path' do
    it 'should find the route correctly' do
      mock_app{ get(named(:some_name, '/some_path/:id')) { params[:id] }}
      get "/some_path/2"

      last_response.status.must_equal 200
      last_response.body.must_equal "2"
    end

    it 'should generate the route correctly' do
      mock_app{ get(named(:some_name, '/some_path/:id')) { url_for(:some_name, id: 3) }}

      get "/some_path/2"

      last_response.status.must_equal 200
      last_response.body.must_equal "/some_path/3"

    end

    it 'should escape unsafe characters correctly' do
      mock_app{ get(named(:some_name, '/some_path/:id')) { url_for(:some_name, {:id => '/', 'k!ey' => 'v&lue'}) }}
      get "/some_path/foo"

      last_response.status.must_equal 200
      last_response.body.must_equal "/some_path/%2F?k%21ey=v%26lue"
    end

  end

  describe 'with namespaces' do
    it 'should handle routes inside a namespace' do

      mock_app do
        namespace named(:admin) do
          get(named(:some_name, '/some_path/:id')) { url_for(:admin, :some_name, id: 3) }
        end
      end

      get "/admin/some_path/2"

      last_response.status.must_equal 200
      last_response.body.must_equal "/admin/some_path/3"
    end

    it 'should handle routes inside a nested namespace xxx' do

      mock_app do
        namespace named(:admin) do
          namespace named(:namespace) do
            get(named(:some_name, '/some_path/:id')) { url_for(:admin, :namespace, :some_name, id: 3) }
          end
        end
      end

      get "/admin/namespace/some_path/2"

      last_response.status.must_equal 200
      last_response.body.must_equal "/admin/namespace/some_path/3"
    end

    it 'should handle defining the same namespace route twice' do

      mock_app do
        namespace named(:admin) do
          namespace named(:namespace) do
            get(named(:some_name, '/some_path/:id')) { url_for(:admin, :namespace, :some_name, id: 3) }
          end
        end

        namespace named(:admin) do
          get(named(:other_name, '/other_path/:id')) { url_for(:admin, :other_name, id: 3) }
        end
      end

      get "/admin/namespace/some_path/2"

      last_response.status.must_equal 200
      last_response.body.must_equal "/admin/namespace/some_path/3"
    end
  end

end
