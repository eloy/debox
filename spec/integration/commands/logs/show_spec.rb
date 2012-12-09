require 'spec_helper'

describe 'logs' do
  it 'should call API::logs_show' do
    Debox::API.should_receive(:logs_show).with('test', 'prod', 'last')
    run_command 'logs test prod'
  end
end
