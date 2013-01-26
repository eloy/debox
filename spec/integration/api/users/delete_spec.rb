require 'spec_helper'

describe 'users_delete' do
  it 'should delete a user' do
    user = configure_admin
    create_admin 'other@indeos.es'
    response = Debox::API.users_delete user: 'other@indeos.es'
    response.code.should eq '200'
    server.users_list.should eq [user.email]
  end
end
