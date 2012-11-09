require 'debox/command/base'

class Debox::Command::Live < Debox::Command::Base

  help :index, params: ['application', 'enviroment'], text: 'Live log for application'
  def index
    deploy_params = { app: args[0], env: args[1] }
    Debox::API.live_log(deploy_params) do |chunk|
      puts chunk
    end
  end

end
