require 'debox/command/base'

class Debox::Command::Deploy < Debox::Command::Base

  help :index, params: ['application', 'enviroment'], text: 'Deploy application'
  def index
    deploy_params = { app: args[0], env: args[1] }
    if args.length > 2
      deploy_params[:task] = args[2]
    end
    Debox::API.deploy(deploy_params) do |chunk|
      puts chunk
    end
  end

end
