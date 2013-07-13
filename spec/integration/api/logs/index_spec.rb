require 'spec_helper'

describe 'logs' do
  it 'should return all the logs' do
    server.create_recipe('test', 'production', 'content')
    job = Job.new error: 'Log result'
    Recipe.any_instance.should_receive(:jobs).and_return [job]

    configure_admin

    logs = Debox::API.logs app: 'test', env: 'production'
    logs.count.should eq 1
    saved = logs.first

    saved[:error].should eq 'Log result'
  end

  it 'should set default env if not set and only one available' do
    server.create_recipe('test', 'production', 'content')
    job = Job.new error: 'Log result'
    Recipe.any_instance.should_receive(:jobs).and_return [job]

    configure_admin

    logs = Debox::API.logs app: 'test'
    logs.count.should eq 1
    saved = logs.first

    saved[:error].should eq 'Log result'
  end

  it 'should empty array withut logs' do
    server.create_recipe('test', 'production', 'content')
    configure_admin
    logs = Debox::API.logs app: 'test', env: 'production'
    logs.should be_empty
  end

  it 'should return invalid if app does not exists' do
    configure_admin
    expect {
      Debox::API.logs app: 'test', env: 'production'
    }.to raise_error Debox::DeboxServerException, "400: Couldn't find App with name = test"

  end

end
