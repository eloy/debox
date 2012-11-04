require 'debox/command/base'

class Debox::Command::Auth < Debox::Command::Base
  include Debox::Utils

  namespace_help 'Auth commands.'

  help :users_new, 'Create user'
  def users_new
    email = ask_email
    password = ask_password_with_confirmation
    respose = Debox::API.users_create user: email, password: password
  end

  help :users_list, "List all users in the debox server"
  def users_list
    users = Debox::API.users
    users.each do |user|
      notice user
    end
  end

end
