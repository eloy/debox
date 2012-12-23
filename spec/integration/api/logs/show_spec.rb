require 'spec_helper'
describe 'log' do
  it 'should return the log' do
    out = OpenStruct.new time: DateTime.now, success: true, buffer: 'Some log content', error: 'Log result'
    server.create_recipe('test', 'production', 'content')
    job = stubbed_job 'test', 'production', 'deploy', out
    job.save_log

    configure_user

    log = Debox::API.log app: 'test', env: 'production'
    log.should eq 'Some log content'
  end

  it 'should return the log without env' do
    out = OpenStruct.new time: DateTime.now, success: true, buffer: 'Some log content', error: 'Log result'
    server.create_recipe('test', 'production', 'content')
    job = stubbed_job 'test', 'production', 'deploy', out
    job.save_log

    configure_user

    log = Debox::API.log app: 'test'
    log.should eq 'Some log content'
  end

end
