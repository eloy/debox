require 'debox/command/base'

class Debox::Command::Log < Debox::Command::Base
  include Debox::Utils

  help :index, params: ['application'],opt_params: ['environment', 'index'],
  text: "Show log. Last by default"

  def index
    opt = { app: args[0] }
    opt[:env] = args[1] if args.length > 1
    opt[:index] = args[2] if args.length > 2

    puts Debox::API.log opt
  end

end
