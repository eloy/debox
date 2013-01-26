require 'spec_helper'
describe 'users_create' do
  it 'should create an user' do
    configure_admin
    response = Debox::API.users_create email: 'new@indeos.es', password: 'secret'
    response.code.should eq '201'
  end
end
