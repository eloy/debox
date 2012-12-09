require 'spec_helper'

describe 'key:show' do
  it 'should call API:public_key' do
    Debox::API.should_receive(:public_key).and_return 'sample_public_key'
    run_command 'key:show'
  end
end


describe 'key:copy' do
  it 'should fail without host' do
    Debox::API.should_not_receive(:public_key)
    Object.any_instance.should_not_receive(:system)
    run_command 'key:copy'
  end

  it 'should call copy the public key' do
    Debox::API.should_receive(:public_key).and_return 'sample_public_key'
    Object.any_instance.should_receive(:system).
      with "echo \"sample_public_key\" | ssh sample.host \"umask 077; test -d .ssh || mkdir .ssh ; cat >> .ssh/authorized_keys\" || exit 1  "
    run_command 'key:copy sample.host'
  end
end
