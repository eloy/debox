require 'spec_helper'

describe 'logs list' do
  it 'should call API::logs_lists with app' do
    Debox::API.should_receive(:logs).with(app: 'test') { [] }
    run_command 'logs test'
  end

  it 'should call API::logs_lists with app and env if given' do
    Debox::API.should_receive(:logs).with(app: 'test', env: 'prod') { [] }
    run_command 'logs test prod'
  end

end
