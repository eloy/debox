require 'debox/command/base'

class Debox::Command::Live < Debox::Command::Base

  help :index, params: ['application', 'enviroment'], text: 'Live log for application'
  def index
    opt = { app: args[0] }
    opt[:env] = args[1] if args[1]
    Debox::API.live(opt) do |chunk|
      puts chunk
    end
  end

end
