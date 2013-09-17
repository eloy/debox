require 'spec_helper'
describe 'log' do
  it 'should return the log' do
    server.create_recipe('test', 'production', 'content')
    job = Job.new error: 'Log result', log: 'Some log content'
    jobs = double('jobs')
    jobs.should_receive(:last).and_return job
    Recipe.any_instance.should_receive(:jobs).and_return jobs

    configure_admin

    log = Debox::API.log app: 'test', env: 'production'
    log.should eq 'Some log content'
  end

  it 'should return the log without env' do
    server.create_recipe('test', 'production', 'content')
    job = Job.new error: 'Log result', log: 'Some log content'
    jobs = double('jobs')
    jobs.should_receive(:last).and_return job
    Recipe.any_instance.should_receive(:jobs).and_return jobs

    configure_admin

    log = Debox::API.log app: 'test'
    log.should eq 'Some log content'
  end

end
