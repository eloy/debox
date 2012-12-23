require 'debox/command/base'

class Debox::Command::Apps < Debox::Command::Base
  include Debox::Utils

  help :index, "List apps and envs"
  def index
    Debox::API.apps.each do |app|
      name = app[:app]
      envs = app[:envs].join ', '
      notice "* #{name} [#{envs}]"
    end
  end
end
