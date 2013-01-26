# Start a debox server in a new thread
def debox_server_start(port)
  Thread.new do
    Thin::Server.start('127.0.0.1', port, DeboxServer::DeboxAPI)
  end
  sleep 1
end

def server
  @debox_server ||= DeboxServer::Core.new
end

def create_admin(email='debox@indeos.es')
  user = server.add_user email, 'secret', admin: true
  return user
end

# Create a user and stub configuration
def configure_admin(user=create_admin)
  Debox::Config.stub(:config).and_return host: 'localhost', port: DEBOX_SERVER_PORT, user: user.email, api_key: user.api_key
  return user
end

# Stub configuration for match spec settings
def configure
  Debox::Config.stub(:config).and_return host: 'localhost', port: DEBOX_SERVER_PORT
end

# Build a job with stdout and capistrano methos stubbed
def stubbed_job(app, env, task='deploy', out=nil)
  out = OpenStruct.new time: DateTime.now, success: true unless out
  job = DeboxServer::Job.new(app, env, task)
  job.stub(:stdout) { out }
  job.stub(:capistrano) { { } }
  return job
end

def run_command(args_str, options={})
  args = args_str.split
  given_command = args.shift.strip
  command = Debox::Command.get_command given_command
  Debox::Command.run(command, options, args)
end
