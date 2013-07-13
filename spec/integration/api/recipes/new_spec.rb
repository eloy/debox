require 'spec_helper'

describe 'recipes new' do

  xit 'should create a new config file with the content of the template' do

    configure_admin
    response = Debox::API.recipes_new app: 'test_app', env: 'production'
    response.should match 'test_app'
    response.should match 'PRODUCTION'
  end
end
