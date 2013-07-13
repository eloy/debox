require 'spec_helper'

describe 'users' do
  it 'should return users' do
    user = create_admin
    configure_admin user
    create_admin 'other@email.com'
    Debox::API.users.should eq [user.email, 'other@email.com']
  end
end
