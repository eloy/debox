require 'debox/command/base'

class Debox::Command::Logs < Debox::Command::Base
  include Debox::Utils

  help :index, params: ['application'], opt_params: ['environment'],text: "List logs for application and env"
  def index
    opt = { app: args[0] }
    opt[:env] = args[1] if args[1]

    Debox::API.logs(opt).each do |log|
      puts format_log_info(log)
    end
  end

  private

  def format_log_info(log)
    l = []
    l << log[:job_id]
    l << log[:status]
    l << log[:task]
    l << DateTime.parse(log[:time]).to_s
    l << log[:error]
    l.join "\t"
  end
end
