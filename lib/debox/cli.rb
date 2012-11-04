class Debox::CLI
  include Debox::Utils

  def initialize(*args)
    @args = args
    option_parser.parse! args
  end

  # Run the command requested in the command line
  def run_command(args)
    Debox::Command.load
    given_command = args.shift.strip rescue "help"
    if given_command == 'help' || options[:show_help]
      help_and_exit
    end
    command = Debox::Command.get_command given_command
    unless command
      puts "Invalid command"
      help_and_error
    end

    Debox::Config.merge_command_line_options! options
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

  def help_show
    puts "Usage: debox command [options]"
    puts "Commands:"
    Debox::Command.commands.values.each do |cmd|
      puts help_content cmd
    end
    puts option_parser.help
  end

  def help_content(cmd)
    help = cmd[:help]
    command = cmd[:command]
    params_str = help[:params].join ' '
    help_text = help[:text]
    command_str = "    #{command} #{params_str}".ljust(50)
    "#{command_str} # #{help_text}"
  end

  def help_and_exit
    help_show
    exit 0
  end


  def help_and_error
    help_show
    exit 1
  end

  def options
    @options ||= {}
  end


  def new_option_parser
    OptionParser.new do |opts|
      opts.banner = "Options:"
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

      opts.on("-?", "--help", "Show this help") do |v|
        options[:show_help] = true
      end


      # opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
      #     options[:verbose] = v
      # end


    end
  end

end
