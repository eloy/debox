require 'spec_helper'
describe 'cap' do

  it 'should deal with invalid app' do
    configure_admin
    DeboxServer::jobs_queue.should_not_receive(:add)
    expect {
      Debox::API.cap(app: 'test')
    }.to raise_error Debox::DeboxServerException, "400: Couldn't find App with name = test"
  end

  it 'should deal with invalid env' do
    configure_admin
    server.create_recipe('test', :production, 'invalid content')
    DeboxServer::jobs_queue.should_not_receive(:add)
    expect {
      Debox::API.cap(app: 'test', env: 'invalid')
    }.to raise_error Debox::DeboxServerException, "400: Couldn't find Recipe with name = invalid"
  end

  it 'should run a cap task gith a given app' do
    configure_admin
    server.create_recipe('test', :production, 'invalid content')
    DeboxServer::jobs_queue.should_receive(:add)

    job = Debox::API.cap app: 'test'
    job[:app].should eq 'test'
    job[:env].should eq 'production'
    job[:task].should eq 'deploy'
  end

  it 'should run a cap task gith a given app and env' do
    configure_admin
    server.create_recipe('test', :production, 'invalid content')
    server.create_recipe('test', :staging, 'invalid content')
    DeboxServer::jobs_queue.should_receive(:add)

    job = Debox::API.cap app: 'test', env: 'staging'
    job[:app].should eq 'test'
    job[:env].should eq 'staging'
    job[:task].should eq 'deploy'
  end


  it 'should run a cap task gith a given app and env' do
    configure_admin
    server.create_recipe('test', :production, 'invalid content')
    server.create_recipe('test', :staging, 'invalid content')
    DeboxServer::jobs_queue.should_receive(:add)

    job = Debox::API.cap app: 'test', env: 'staging', task: 'node:setup'
    job[:app].should eq 'test'
    job[:env].should eq 'staging'
    job[:task].should eq 'node:setup'
  end


end
