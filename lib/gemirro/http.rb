# -*- coding: utf-8 -*-

module Gemirro
  ##
  # The Http class is responsible for executing GET request
  # to a specific url and return an response as an HTTP::Message
  #
  # @!attribute [r] client
  #  @return [HTTPClient]
  #
  class Http
    attr_accessor :client

    ##
    # Requests the given HTTP resource.
    #
    # @param [String] url
    # @return [HTTP::Message]
    #
    def self.get(url)
      # break url apart to check for user/password
      uri = URI(url)
      # set basic auth if user and password provided in url
      if uri.user && uri.password
        clean_url = uri.scheme + '://' + uri.host + uri.path
        client.set_auth(clean_url, uri.user, uri.password)
        response = client.get(clean_url, follow_redirect: true)
      else
        response = client.get(url, follow_redirect: true)
      end

      unless HTTP::Status.successful?(response.status)
        fail HTTPClient::BadResponseError, response.reason
      end

      response
    end

    ##
    # @return [HTTPClient]
    #
    def self.client
      @client ||= HTTPClient.new
    end
  end
end
