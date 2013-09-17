require 'debox/command/base'

class Debox::Command::Live < Debox::Command::Base

  help :log, params: ['job_id'], text: 'Live log for job'
  def log
    opt = { app: args[0] }
    opt[:env] = args[1] if args[1]
    Debox::API.live(opt) do |chunk|
      puts chunk
    end
  end


  help :notifications, text: 'Live notifications'
  def notifications
    Debox::API.notifications do |chunk|
      puts chunk
    end
  end

end
