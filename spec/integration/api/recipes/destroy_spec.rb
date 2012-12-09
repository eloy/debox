require 'spec_helper'

describe 'recipes_delete' do


  it 'should destroy the recipe if exists' do
    configure_user
    server.create_recipe('test', :staging, 'sample content')
    server.create_recipe('test', :production, 'sample content')
    response = Debox::API.recipes_destroy app: 'test', env: 'staging'
    response.code.should eq '200'
    server.recipes_list('test').should eq ['production']
  end
end
