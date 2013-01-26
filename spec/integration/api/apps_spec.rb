require 'spec_helper'

describe 'apps' do
  it 'should return apps' do
    configure_admin
    server.create_recipe('test_app', :production, 'this is the first content')
    Debox::API.apps.should eq [{:app=>"test_app", :envs=>["production"]}]
  end
end
