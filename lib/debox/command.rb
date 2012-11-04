require 'optparse'
require 'debox/utils'
require 'debox/api'
require "highline/import"

module Debox

  module Command
    include Debox::Utils

    attr_reader :options

    def self.run(command, options={}, args=[])
      begin
        command_instance = command[:klass].new(args, options)
        method = command[:method]
        command_instance.send(method)
      rescue Interrupt, StandardError=> error
        puts error
        puts error.backtrace
      rescue SystemExit => error
        puts "Bye bye"
      end
    end


    def self.commands
      @@commands ||= {}
    end

    def self.register_command(command)
      commands[command[:command]] = command
    end


    def self.get_command(cmd)
      commands[cmd]
    end

    # Require all commands
    def self.load
      Dir[File.join(File.dirname(__FILE__), "command", "*.rb")].each do |file|
        require file
      end
    end

  end
end
