class Debox::Command::Base
  include Debox::Utils

  attr_reader :args
  attr_reader :options

  def initialize(args=[], options={})
    @args = args
    @options = options
  end

  protected

  def self.namespace
    self.to_s.split("::").last.downcase
  end

  def self.method_added(method)
    return if self == Debox::Command::Base
    return if private_method_defined?(method)
    return if protected_method_defined?(method)
    resolved_method = (method.to_s == "index") ? nil : method.to_s
    command = [ self.namespace, resolved_method ].compact.join(":")
    cmd = {
      klass: self,
      method: method,
      command: command
    }
    Debox::Command.register_command cmd
  end
end
