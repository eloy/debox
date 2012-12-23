require 'spec_helper'

describe 'logs' do
  it 'should return all the logs' do
    time = DateTime.now
    out = OpenStruct.new time: time, success: true, buffer: 'Some log content', error: 'Log result'
    server.create_recipe('test', 'production', 'content')
    job = stubbed_job 'test', 'production', 'deploy', out
    job.save_log

    configure_user

    logs = Debox::API.logs app: 'test', env: 'production'
    logs.count.should eq 1
    saved = logs.first
    DateTime.parse(saved[:time]).to_s.should eq time.to_s
    saved[:error].should eq 'Log result'
    saved[:status].should eq 'success'
  end

  it 'should set default env if not set and only one available' do
    time = DateTime.now
    out = OpenStruct.new time: time, success: true, buffer: 'Some log content', error: 'Log result'
    server.create_recipe('test', 'production', 'content')
    job = stubbed_job 'test', 'production', 'deploy', out
    job.save_log

    configure_user

    logs = Debox::API.logs app: 'test', env: 'production'
    logs.count.should eq 1
    saved = logs.first

    DateTime.parse(saved[:time]).to_s.should eq time.to_s
    saved[:error].should eq 'Log result'
    saved[:status].should eq 'success'
  end

  it 'should empty array withut logs' do
    server.create_recipe('test', 'production', 'content')
    configure_user
    logs = Debox::API.logs app: 'test', env: 'production'
    logs.should be_empty
  end

  it 'should return invalid if app does not exists' do
    configure_user
    expect {
      Debox::API.logs app: 'test', env: 'production'
    }.to raise_error Debox::DeboxServerException, '400: App not found'

  end

end
