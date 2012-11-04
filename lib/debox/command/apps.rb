require 'debox/command/base'

class Debox::Command::Apps < Debox::Command::Base
  include Debox::Utils

  help :index, "List apps"
  def index
    Debox::API.apps.each do |app|
      notice app
    end
  end
end
