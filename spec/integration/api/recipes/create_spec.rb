require 'spec_helper'

describe 'recipes_create' do
  it 'should create a config file with given content' do
    configure_admin
    response = Debox::API.recipes_create app: 'test', env: 'production', content: 'some content'
    response.code.should eq '201'
    server.recipe_content('test', 'production').should eq 'some content'
  end
end
