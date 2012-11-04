class Debox::CLI


  def initialize(*args)
    @args = args
    option_parser.parse! args
  end

  # Run the command requested in the command line
  def run_command(args)
    command = args.shift.strip rescue "help"

    Debox::Config.merge_command_line_options! options

    Debox::Command.load
    Debox::Command.run(command, options, args)
  end


  # Prepare the console and run the command
  def start
    begin
      $stdin.sync = true if $stdin.isatty
      $stdout.sync = true if $stdout.isatty

      # Run the commands
      run_command @args

    rescue Interrupt => error
      puts 'stty icanon echo, Command cancelled.'
      puts error.backtrace
    rescue => error
      puts error
      puts "--------------------------------------------------------------------------------"
      puts error.backtrace
      exit(1)
    end
  end


  def option_parser
    @option_parser ||= new_option_parser
  end

  private


  def options
    @options ||= {}
  end


  def new_option_parser
    OptionParser.new do |opts|
      opts.banner = "Usage: debox command [options]"

      opts.on("-h", "--host SERVER_HOST", "Debox server url") do |host|
        options[:host] = host
        # If host option, set default port unless defined
        options[:port] = 80 unless options[:port]
      end

      opts.on("-p", "--port PORT", "Debox server port") do |port|
        options[:port] = port
      end

      opts.on("-u", "--user EMAIL", "User name") do |u|
        options[:user] = u
      end

      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
          options[:verbose] = v
      end

    end
  end

end
