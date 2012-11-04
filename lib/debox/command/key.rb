require 'debox/command/base'

class Debox::Command::Key < Debox::Command::Base
  include Debox::Utils

  help :show, 'Show the server ssh public key'
  def show
    notice Debox::API.public_key
  end

  help :copy, params: ['target_host'], text: 'Copy the server ssh public key to the target host'
  def copy
    host = args.first
    error_and_exit 'No target host' unless host
    key = Debox::API.public_key
    str = %{echo "#{key}" | ssh #{host} "umask 077; test -d .ssh || mkdir .ssh ; cat >> .ssh/authorized_keys" || exit 1  }
    system str
  end

end
