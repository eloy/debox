require 'spec_helper'

describe 'recipes update' do
  it 'should return the file content' do
    configure_admin
    server.create_recipe('test_app', :production, 'this is the first content')
    response = Debox::API.recipes_update app: 'test_app', env: 'production', content: 'updated content'
    response.code.should eq '200'
    server.recipe_content('test_app', 'production').should eq 'updated content'
  end
end
