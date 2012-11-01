require "net/http"

module Debox
  module API

    # Return the api_key for the user
    # @params:
    #   :host
    #   :user
    #   :password
    def self.api_key(opt)
      post '/api_key', user: opt[:user], password: opt[:password]
    end

    # Create a new user
    # @params:
    #   :host
    #   :user
    #   :password
    def self.users_create(opt)
      post '/api/users/create', user: opt[:user], password: opt[:password]
    end


    def self.post(path, params)
      host = Debox.config[:host]
      port = Debox.config[:port]
      http = Net::HTTP.new(host, port)
      request = Net::HTTP::Post.new(path)
      request.set_form_data(params) if params
      http.request(request)
    end

  end
end
