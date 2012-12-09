require 'spec_helper'

describe 'login' do

  xit 'should call API::api_key' do
    Debox::API.should_receive(:api_key).and_return 'secret_key'
    Debox::Config.should_receive(:save_config)
    run_command 'login', host: 'sample.host'
    Debox::config[:host].should eq 'sample.host'
  end
end
