require "net/http"

module Debox
  module API

    # Return the api_key for the user
    # @params:
    #   :host
    #   :user
    #   :password
    def self.api_key(opt)
      post_raw '/api_key', opt, skip_basic_auth: true
    end

    # apps
    #----------------------------------------------------------------------

    def self.apps
      get '/api/apps'
    end

    # users
    #----------------------------------------------------------------------

    # Create a new user
    # @params:
    #   :host
    #   :user
    #   :password
    def self.users_create(opt)
      post_raw '/api/users/create', user: opt[:user], password: opt[:password]
    end

    def self.users_destroy(opt)
      post_raw '/api/users/destroy', user: opt[:user]
    end


    # Return existing users
    def self.users
      get '/api/users'
    end

    # recipes
    #----------------------------------------------------------------------

    def self.recipes(opt)
      get("/api/recipes/#{opt[:app]}")
    end

    def self.recipes_new(opt)
      get_raw("/api/recipes/#{opt[:app]}/#{opt[:env]}/new").body
    end

    def self.recipes_show(opt)
      get_raw("/api/recipes/#{opt[:app]}/#{opt[:env]}/show").body
    end

    def self.recipes_create(opt)
      post_raw "/api/recipes/#{opt[:app]}/#{opt[:env]}/create", content: opt[:content]
    end

    def self.recipes_update(opt)
      post_raw "/api/recipes/#{opt[:app]}/#{opt[:env]}/update", content: opt[:content]
    end

    def self.recipes_destroy(opt)
      post_raw("/api/recipes/#{opt[:app]}/#{opt[:env]}/destroy")
    end

    # deploy
    #----------------------------------------------------------------------

    def self.deploy(opt, &block)
      path = "/api/deploy/#{opt[:app]}/#{opt[:env]}"
      path += "/#{opt[:task]}" if opt[:task]
      get_raw(path).body
    end

    def self.live_log(opt, &block)
      path = "/api/live_log/#{opt[:app]}/#{opt[:env]}"
      stream(path, nil, {}, block)
    end


    # Public key
    #----------------------------------------------------------------------

    def self.public_key
      get_raw('/api/public_key').body
    end


    # logs
    #----------------------------------------------------------------------

    def self.logs(app, env)
      get "/api/logs/#{app}/#{env}"
    end

    def self.logs_show(app, env, index)
      get "/api/logs/#{app}/#{env}/#{index}"
    end

    private

    # HTTP helpers
    #----------------------------------------------------------------------

    def self.post_raw(path, request_params=nil, options={})
      request :post, path, request_params, options
    end

    def self.post(path, request_params=nil, options={})
      JSON.parse post_raw(path, request_params, options).body, symbolize_names: true
    end

    def self.get_raw(path, request_params=nil, options={})
      request :get, path, request_params, options
    end

    def self.get(path, request_params=nil, options={})
      JSON.parse get_raw(path, request_params, options).body, symbolize_names: true
    end

    # Create a new Net::HTTP request
    def self.new_request(type, path, request_params=nil, options={})
      if type == :post
        request = Net::HTTP::Post.new(path)
        request.set_form_data(request_params) if request_params
      elsif type == :get
        request = Net::HTTP::Get.new(path)
      end

      if !options[:skip_basic_auth] && Debox::Config.logged_in?
        request.basic_auth Debox.config[:user], Debox.config[:api_key]
      end
      return request
    end

    def self.check_errors(response)
      unauthorized_error if response.code == "401"
      server_error if response.code == "500"
      not_found_error if response.code == "404"
      error_and_exit("#{response.code}: #{response.body}") if response.code != "200"
    end

    # Run request
    def self.request(type, path, request_params=nil, options={})
      request = new_request type, path, request_params, options
      http = Net::HTTP.new Debox.config[:host], Debox.config[:port]
      response = http.request(request)
      # Process errors
      check_errors response
      return response
    end

    # Run request and read run block with the chunk
    def self.stream(path, request_params=nil, options={ }, block)
      request = new_request :get, path, request_params, options
      http = http_connection
      http.request(request) do | response|
        check_errors response
        response.read_body do |chunk|
          block.call chunk
        end
      end
    end

    def self.http_connection
      http = Net::HTTP.start(Debox.config[:host], Debox.config[:port])
      # Set timeout to 30 min
      http.read_timeout = 180000
      return http
    end

    # TODO: DRY three methods bellow

    def self.unauthorized_error
      error_and_exit "Access denied. Please login first."
    end


    def self.server_error
      error_and_exit "Ups, something went wrong. Please, try later."
    end

    def self.not_found_error
      error_and_exit "Ups, something went wrong (not found). Please, try to update your client."
    end

    def self.error_and_exit(msg)
      puts msg
      exit 1
    end

  end
end
