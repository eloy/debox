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
    status = log[:success] ? "SUCCESS" : "FAILED"
    start_time = log[:start_time] ? DateTime.parse(log[:start_time]).to_s : ""
    end_time = log[:end_time] ? DateTime.parse(log[:end_time]).to_s : ""

    l = []
    l << log[:id]
    l << status
    l << log[:task]
    l << start_time
    l << log[:error]
    l.join "\t"
  end
end
