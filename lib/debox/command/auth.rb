require 'debox/command/base'

class Debox::Command::Auth < Debox::Command::Base
  include Debox::Utils

  def login
    email = options[:user] || ask_email
    password = ask_password
    response = Debox::API.api_key user: email, password: password
    error_and_exit "Invalid login." unless response.code == "200"
    Debox.config[:api_key] = response.body
    Debox.update_login_config
    notice 'Login successful'
  end

  def create_user
    email = ask_email
    password = ask_password_with_confirmation
    respose = Debox::API.users_create user: email, password: password
  end

end
