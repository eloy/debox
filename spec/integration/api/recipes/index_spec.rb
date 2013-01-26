require 'spec_helper'

describe 'recipes index' do
  it 'should return an empty array without recipes' do
    configure_admin
    Debox::API.recipes(app: 'test').should eq []
  end


  it 'should return current recipes if any' do
    app = 'test'
    server.create_recipe(app, :staging, 'sample content')
    server.create_recipe(app, :production, 'sample content')
    configure_admin
    Debox::API.recipes(app: 'test').should eq ['staging', 'production']
  end
end
