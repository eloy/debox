require 'spec_helper'

describe 'recipes index' do

  it 'should return invalid if app does not exists' do
    configure_admin
    expect {
      Debox::API.recipes(app: 'test')
    }.to raise_error Debox::DeboxServerException, "400: Couldn't find App with name = test"

  end

  it 'should return current recipes if any' do
    app = 'test'
    server.create_recipe(app, :staging, 'sample content')
    server.create_recipe(app, :production, 'sample content')
    configure_admin
    Debox::API.recipes(app: 'test').should eq ['staging', 'production']
  end
end
