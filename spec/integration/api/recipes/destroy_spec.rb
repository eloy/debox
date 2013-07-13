require 'spec_helper'

describe 'recipes_delete' do


  it 'should destroy the recipe if exists' do
    configure_admin
    staging_recipe = server.create_recipe('test', :staging, 'sample content')
    production_recipe = server.create_recipe('test', :production, 'sample content')
    response = Debox::API.recipes_destroy app: 'test', env: 'staging'
    response.code.should eq '200'
    Recipe.all.should eq [production_recipe]
  end
end
