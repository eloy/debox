require 'debox/command/base'

class Debox::Command::Users < Debox::Command::Base
  include Debox::Utils

  help :index, "List all users in the debox server"
  def index
    users = Debox::API.users
    users.each do |user|
      notice user
    end
  end

  help :new, 'Create user'
  def new
    email = args.first unless args.empty?
    email = ask_email unless email
    password = ask_password_with_confirmation
    respose = Debox::API.users_create user: email, password: password
  end

  help :delete, params: ['email'], text: 'Delete user with a given email'
  def delete
    email = args.first
    Debox::API.users_delete user: email
    notice 'User deleted'
  end

end
