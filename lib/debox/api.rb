require "net/http"
require 'base64'

module Debox
  module API

    # Return the api_key for the user
    # @params:
    #   :host
    #   :user
    #   :password
    def self.api_key(opt)
      get_raw '/v1/api_key', opt, skip_basic_auth: true
    end

    # apps
    #----------------------------------------------------------------------
    def self.apps
      get '/v1/apps'
    end

    # users
    #----------------------------------------------------------------------

    # Create a new user
    # @params:
    #   :host
    #   :user
    #   :password
    def self.users_create(opt)
      post_raw '/v1/users/create', user: opt[:user], password: opt[:password]
    end

    def self.users_delete(opt)
      delete_raw '/v1/users/destroy', user: opt[:user]
    end

    # Return existing users
    def self.users
      get '/v1/users'
    end

    # recipes
    #----------------------------------------------------------------------

    def self.recipes(opt)
      get("/v1/recipes/#{opt[:app]}")
    end

    def self.recipes_new(opt)
      get_raw("/v1/recipes/#{opt[:app]}/#{opt[:env]}/new").body
    end

    def self.recipes_show(opt)
      get_raw("/v1/recipes/#{opt[:app]}/#{opt[:env]}").body
    end

    def self.recipes_create(opt)
      post_raw "/v1/recipes/#{opt[:app]}/#{opt[:env]}", content: opt[:content]
    end

    def self.recipes_update(opt)
      put_raw "/v1/recipes/#{opt[:app]}/#{opt[:env]}", content: opt[:content]
    end

    def self.recipes_destroy(opt)
      delete_raw("/v1/recipes/#{opt[:app]}/#{opt[:env]}")
    end

    # Cap
    #----------------------------------------------------------------------

    def self.cap(opt, &block)
      path = "/v1/cap/#{opt[:app]}"
      path += "/#{opt[:env]}" if opt[:env]
      path += "?task=#{opt[:task]}" if opt[:task]
      get(path)
    end

    # Public key
    #----------------------------------------------------------------------

    def self.public_key
      get_raw('/v1/public_key').body
    end

    # logs
    #----------------------------------------------------------------------

    def self.live(opt, &block)
      path = "/v1/live/log/#{opt[:app]}"
      path += "/#{opt[:env]}" if opt[:env]

      stream path, nil, { }, block

      # host = "http://#{Debox.config[:host]}:#{Debox.config[:port]}"
      # auth = [Debox.config[:user], Debox.config[:api_key]].join(':')
      # query = { }
      # headers = { 'Authorization' =>  "Basic #{Base64.encode64 auth}" }
      # EM.run do
      #   source = EventMachine::EventSource.new("#{host}#{path}", query, headers )
      #   source.message do |m|
      #     block.call m
      #   end

      #   source.open do
      #     puts "Connection opened"
      #   end

      #   source.close do
      #     puts "Connection closed"
      #     EM.stop
      #   end

      #   source.error do |error|
      #     puts "ERROR: #{error}"
      #     EM.stop
      #   end

      #   source.start
      # end
    end

    def self.logs(opt)
      path = "/v1/logs/#{opt[:app]}"
      path += "/#{opt[:env]}" if opt[:env]
      get path
    end

    def self.logs_show(app, env, index)
      get_raw("/v1/logs/#{app}/#{env}/#{index}").body
    end

    private

    # HTTP helpers
    #----------------------------------------------------------------------

    def self.post_raw(path, request_params=nil, options={})
      run_request :post, path, request_params, options
    end

    def self.post(path, request_params=nil, options={})
      JSON.parse post_raw(path, request_params, options).body, symbolize_names: true
    end

    def self.get_raw(path, request_params=nil, options={})
      run_request :get, path, request_params, options
    end

    def self.get(path, request_params=nil, options={})
      JSON.parse get_raw(path, request_params, options).body, symbolize_names: true
    end

    def self.put_raw(path, request_params=nil, options={})
      run_request :put, path, request_params, options
    end

    def self.put(path, request_params=nil, options={})
      JSON.parse put_raw(path, request_params, options).body, symbolize_names: true
    end

    def self.delete_raw(path, request_params=nil, options={})
      run_request :delete, path, request_params, options
    end

    def self.delete(path, request_params=nil, options={})
      JSON.parse delete_raw(path, request_params, options).body, symbolize_names: true
    end


    # Create a new Net::HTTP request
    def self.new_request(type, path, request_params=nil, options={})
      if type == :post
        request = Net::HTTP::Post.new(path)
      elsif type == :put
        request = Net::HTTP::Put.new(path)
      elsif type == :get
        request = Net::HTTP::Get.new(path)
      elsif type == :delete
        request = Net::HTTP::Delete.new(path)
      else
        error_and_exit "Invalid request type: #{type}"
      end

      request.set_form_data(request_params) if request_params

      if !options[:skip_basic_auth] && Debox::Config.logged_in?
        request.basic_auth Debox.config[:user], Debox.config[:api_key]
      end
        return request
    end

    def self.is_valid_response?(response)
      !response.code.match(/^20/).nil?
    end

    def self.check_errors(response)
      unauthorized_error if response.code == "401"
      server_error if response.code == "500"
      not_found_error if response.code == "404"
      error_and_exit("#{response.code}: #{response.body}") unless is_valid_response? response
    end

    # Run request
    def self.run_request(type, path, request_params=nil, options={})
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
      raise DeboxServerException.new msg
    end
  end

  class DeboxServerException < Exception
  end
end
