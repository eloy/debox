require 'debox/command/base'

class Debox::Command::Status < Debox::Command::Base

  help :index, text: 'Show server status'
  def index
    status = Debox::API.status
    puts status
  end

end
