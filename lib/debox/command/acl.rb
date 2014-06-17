require 'debox/command/base'

class Debox::Command::Acl < Debox::Command::Base
  include Debox::Utils

  help :show, params: ['application', 'environment', 'user'], text: 'Show acl for the given user'
  def show
    app = args[0]
    env = args[1]
    user = args[2]
    puts Debox::API.acl_show app: app, env: env, user: user
  end

  help :add, params: ['application', 'environment', 'user', 'action'], text: 'Add acl for the given user'
  def add
    app = args[0]
    env = args[1]
    user = args[2]
    action = args[3]
    puts Debox::API.acl_add app: app, env: env, user: user, action: action
  end


end
