# Sinatra::NamedRoutes

Allows you to name routes on definition and build them by name using the `url_for` helper.

## Installation

Add this line to your application's Gemfile:

    gem 'sinatra-named_routes'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sinatra-named_routes

## Usage

1- Register the extension

    register Sinatra::NamedRoutes

If you are using modular style apps, you must include the helper explicitly in the `Sinatra::Base` subclasses by doing:

    helpers Sinatra::NamedRoutes::Helpers

2- Name your routes when defining them

    get named(:name, '/path') do
      ...
    end

    get named(:short) do
      ...
    end

3- Access the routes in your views

    url_for(:name) #=> '/path'
    url_for(:short) #=> '/short'

### Params

You can pass paramaters to the route like so:

    get named(:with_params, '/path/:id') do
      ...
    end


    url_for(:with_params, id: 2) #=> '/path/2'


### Namespaces

Named routes work with namespaces too:

    namespace name(:admin) do
      get named(:page, '/page/:id') do
      end
    end


    url_for(:admin, :page, id: 3) #=> '/admin/page/3'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
