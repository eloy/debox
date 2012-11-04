require 'debox/command/base'

class Debox::Command::Deploy < Debox::Command::Base

  help :index, params: ['application', 'enviroment'], text: 'Deploy application'
  def index
    app = args.first
    env = args.last
    Debox::API.deploy(app: app, env: env) do |chunk|
      puts chunk
    end
  end

end
