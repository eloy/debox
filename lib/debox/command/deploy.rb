require 'debox/command/base'

class Debox::Command::Deploy < Debox::Command::Base

  def index
    app = args.first
    env = args.last
    Debox::API.deploy(app: app, env: env) do |chunk|
      puts chunk
    end
  end

end
