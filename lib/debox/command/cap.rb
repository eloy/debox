require 'debox/command/base'

class Debox::Command::Cap < Debox::Command::Base

  help :index, params: ['task', 'application'], opt_params: ['environment'], text: 'Deploy application'
  def index
    deploy_params = { task: args[0], app: args[1] }
    deploy_params[:env] = args[2] if args.count == 3
    cap_request = Debox::API.cap(deploy_params)
    job_id = cap_request[:job_id]
    Debox::API.live(job_id: job_id) do |chunk|
      puts chunk
    end
  end

end
