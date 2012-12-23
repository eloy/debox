require 'spec_helper'
describe 'cap' do

  it 'should deal with invalid app' do
    configure_user
    DeboxServer::Deployer.should_not_receive(:add_job_to_queue)
    expect {
      Debox::API.cap(app: 'test')
    }.to raise_error Debox::DeboxServerException, '400: App not found'
  end

  it 'should deal with invalid env' do
    configure_user
    server.create_recipe('test', :production, 'invalid content')
    DeboxServer::Deployer.should_not_receive(:add_job_to_queue)
    expect {
      Debox::API.cap(app: 'test', env: 'invalid')
    }.to raise_error Debox::DeboxServerException, '400: Environment not found.'
  end

  it 'should run a cap task gith a given app' do
    configure_user
    server.create_recipe('test', :production, 'invalid content')
    DeboxServer::Deployer.should_receive(:add_job_to_queue)

    job = Debox::API.cap app: 'test'
    job[:app].should eq 'test'
    job[:env].should eq 'production'
    job[:task].should eq 'deploy'
  end

  it 'should run a cap task gith a given app and env' do
    configure_user
    server.create_recipe('test', :production, 'invalid content')
    server.create_recipe('test', :staging, 'invalid content')
    DeboxServer::Deployer.should_receive(:add_job_to_queue)

    job = Debox::API.cap app: 'test', env: 'staging'
    job[:app].should eq 'test'
    job[:env].should eq 'staging'
    job[:task].should eq 'deploy'
  end


  it 'should run a cap task gith a given app and env' do
    configure_user
    server.create_recipe('test', :production, 'invalid content')
    server.create_recipe('test', :staging, 'invalid content')
    DeboxServer::Deployer.should_receive(:add_job_to_queue)

    job = Debox::API.cap app: 'test', env: 'staging', task: 'node:setup'
    job[:app].should eq 'test'
    job[:env].should eq 'staging'
    job[:task].should eq 'node:setup'
  end


end
