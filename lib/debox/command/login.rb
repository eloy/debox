require 'debox/command/base'

class Debox::Command::Login < Debox::Command::Base
  include Debox::Utils

  namespace_help 'Login.'

  help :index, 'Login in the debox server. Require -h param.'
  def index
    email = options[:user] || ask_email
    password = ask_password
    response = Debox::API.api_key user: email, password: password
    error_and_exit "Invalid login." unless response.code == "200"
    Debox.config[:api_key] = response.body
    Debox::Config.update_login_config
    notice 'Login successful'
  end
end
