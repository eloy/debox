require 'spec_helper'

describe 'cap command' do
  it 'should call API::cap and API::live' do
    Debox::API.should_receive(:cap).with(app: 'test', env: 'prod', task: 'deploy').and_return job_id: 1
    Debox::API.should_receive(:live).with(job_id: 1)
    run_command 'cap deploy test prod'
  end

  it 'env is optional' do
    Debox::API.should_receive(:cap).with(app: 'test', task: 'deploy').and_return job_id: 1
    Debox::API.should_receive(:live).with(job_id: 1)
    run_command 'cap deploy test'
  end


end
