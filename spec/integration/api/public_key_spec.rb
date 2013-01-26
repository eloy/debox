require 'spec_helper'

describe 'public_key' do

  it 'should return the public key if generated' do
    configure_admin

    # Stub the rsa file
    public_key_file = double 'file'
    public_key_file.stub(:read).and_return 'id_rsa.pub content'
    File.should_receive(:open).with(DeboxServer::SshKeys::PUBLIC_KEY).and_return public_key_file

    Debox::API.public_key.should eq 'id_rsa.pub content'
  end
end
