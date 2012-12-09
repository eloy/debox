require 'spec_helper'

# Return api key for a given user
describe 'api_keys' do

  it 'should return  api key with invalid credentials' do
    configure
    expect {
      Debox::API.api_key user: 'invalid@indeos.es', password: 'invalid'
    }.to raise_error Debox::DeboxServerException, 'Access denied. Please login first.'

  end

  it 'should return the user api key with valid credentials' do
    user = create_user
    configure
    response = Debox::API.api_key user: user.email, password: 'secret'
    response.body.should eq user.api_key
  end
end
