module Debox

  # Convenient shortcut to Debox::Config.config
  def self.config
    Debox::Config.config
  end

  module Config

    CONFIG_FILE_NAME=".deboxrc"

    def self.config
      @@config ||= read_config
    end

    # Merge given options with current config
    def self.merge_command_line_options!(options)
      config.merge! options
    end

    # Update login values in the config
    def self.update_login_config
      current = read_config
      current.merge! host: config[:host], port: config[:port], user: config[:user], api_key: config[:api_key]
      save_config current
    end

    # Return true if the user has login information
    def self.logged_in?
      config[:api_key] && config[:api_key].length > 0
    end

    private

    # Read the config from the filesystem
    def self.read_config
      return defaults unless File.exists? user_config_file
      YAML.load_file user_config_file
    end

    def self.save_config(current=config)
      f = File.open(user_config_file, 'w')
      f.write(current.to_yaml)
      f.close
    end

    # Return defaults values
    def self.defaults
      { host: 'localhost', port: 80 }
    end

    # Return config file full path
    def self.user_config_file
      File.join ENV['HOME'], CONFIG_FILE_NAME
    end
  end
end
