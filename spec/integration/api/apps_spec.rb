require 'spec_helper'

describe 'apps' do
  it 'should return apps' do
    configure_user
    server.create_recipe('test_app', :production, 'this is the first content')
    Debox::API.apps.should eq ['test_app']
  end
end
