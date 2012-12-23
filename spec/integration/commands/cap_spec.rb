require 'spec_helper'

describe 'cap command' do
  it 'should call API::cap and API::live' do
    Debox::API.should_receive(:cap).with(app: 'test', env: 'prod', task: 'deploy').and_return '1'
    Debox::API.should_receive(:live).with(app: 'test', env: 'prod', task: 'deploy')
    run_command 'cap deploy test prod'
  end

  it 'env is optional' do
    Debox::API.should_receive(:cap).with(app: 'test', task: 'deploy').and_return '1'
    Debox::API.should_receive(:live).with(app: 'test', task: 'deploy')
    run_command 'cap deploy test'
  end


end
