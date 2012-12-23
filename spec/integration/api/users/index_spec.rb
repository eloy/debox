require 'spec_helper'

describe 'users' do
  it 'should return users' do
    user = create_user
    configure_user user
    create_user 'other@email.com'
    Debox::API.users.should eq ['other@email.com', user.email]
  end
end
