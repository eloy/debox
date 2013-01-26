require 'spec_helper'

describe '/v1/recipes/:app/:env/show' do
  it 'should return the file content' do
    configure_admin
    server.create_recipe('test_app', :production, 'this is the first content')
    recipe = Debox::API.recipes_show app: 'test_app', env: 'production'
    recipe.should eq 'this is the first content'
  end
end
