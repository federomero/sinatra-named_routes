require 'minitest/autorun'

require 'sinatra/named_routes/router'

describe Sinatra::NamedRoutes::Router do

  subject do
    Sinatra::NamedRoutes::Router.new(:root, '')
  end

  it 'should handle a simple route' do
    subject.set('/admin', :admin)
    subject.get(:admin).must_equal '/admin'
  end

  it 'should allow to set a route with params' do
    subject.set('/petition/:id', :petition)
    subject.get(:petition, id: 2).must_equal '/petition/2'
  end

  it 'should allow to nest routes' do
    subject.set('/admin', :admin)
    subject.set('/petition/:id', :petition, [:admin])
    subject.get(:admin, :petition, id: 2).must_equal '/admin/petition/2'
  end

  it "should not allow to use the same name with different patterns" do
    proc {
      subject.set('/one', :name)
      subject.set('/two', :name)
    }.must_raise Sinatra::NamedRoutes::Exceptions::RouteNameTaken
  end
end
