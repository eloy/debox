require 'spec_helper'

describe 'logs' do
  it 'should call API::logs' do
    Debox::API.should_receive(:log).with(app: 'test', env: 'prod')
    run_command 'log test prod'
  end

  it 'should call API::logs_show' do
    Debox::API.should_receive(:log).with(app: 'test', env: 'prod')
    run_command 'log test prod'
  end

end
