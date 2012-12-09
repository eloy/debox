class Debox::Command::Base
  include Debox::Utils

  attr_reader :args
  attr_reader :options

  def initialize(args=[], options={})
    @args = args
    @options = options
  end

  # Register help for given namespace
  def self.namespace_help(help_txt)
    @@namespace_help = help_txt
  end

  # Register help for given method
  def self.help(method, options)
    if options.is_a? Hash
      help_text = options[:text]
      params = options[:params] || []
      opt_params = options[:opt_params] || []
    else
      help_text = options
      params = []
      opt_params = []
    end
    help_methods[method] = { text: help_text, params: params, opt_params: opt_params }
  end

  # Help for methods
  def self.help_methods
    @@help_methods ||= { }
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
      command: command,
      help: help_methods[method]
    }
    Debox::Command.register_command cmd

  end
end
