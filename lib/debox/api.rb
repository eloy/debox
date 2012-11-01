require "net/http"

module Debox
  module API

    # Return the api_key for the user
    # @params:
    #   :host
    #   :user
    #   :password
    def self.api_key(opt)
      post '/api_key', opt, skip_basic_auth: true
    end

    # Create a new user
    # @params:
    #   :host
    #   :user
    #   :password
    def self.users_create(opt)
      post '/api/users/create', user: opt[:user], password: opt[:password]
    end

    # Return existing users
    def self.users
      get '/api/users'
    end

    private

    def self.post_raw(path, request_params=nil, options={})
      request :post, path, request_params, options
    end

    def self.post(path, request_params=nil, options={})
      JSON.parse post_raw(path, request_params, options).body
    end


    def self.get_raw(path, request_params=nil, options={})
      request :get, path, request_params, options
    end

    def self.get(path, request_params=nil, options={})
      JSON.parse get_raw(path, request_params, options).body
    end


    def self.request(type, path, request_params=nil, options={})
      http = Net::HTTP.new Debox.config[:host], Debox.config[:port]
      if type == :post
        request = Net::HTTP::Post.new(path)
        request.set_form_data(request_params) if request_params
      elsif type == :get
        request = Net::HTTP::Get.new(path)
      end

      if !options[:skip_basic_auth] && Debox::Config.logged_in?
        request.basic_auth Debox.config[:user], Debox.config[:api_key]
      end
      response = http.request(request)
      unauthorized_error if response.code == "401"
      server_error if response.code == "500"
      return response
    end


    # TODO: DRY three methods bellow

    def self.unauthorized_error
      error_and_exit "Access denied. Please login first."
    end


    def self.server_error
      error_and_exit "Ups, something went wrong. Please, try later."
    end


    def self.error_and_exit(msg)
      puts msg
      exit 1
    end

  end
end
