ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'bundler'
require 'rack'
require 'debox_server'
Bundler.require

require 'rspec/mocks'
# require 'webmock/rspec'

# Setup mocks
RSpec::Mocks::setup(Object.new)

# Load commands
Debox::Command.load

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

# Start a debox server for tests
DEBOX_SERVER_PORT = 9393
debox_server_start DEBOX_SERVER_PORT

RSpec.configure do |config|

  # Cleanup database after each test
  config.after(:each) do
    DeboxServer::RedisDB.flush_test_db
  end

end
