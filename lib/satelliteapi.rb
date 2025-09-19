# frozen_string_literal: true

require 'json'
require 'pp'
require 'rest-client'
require 'socket'

require_relative 'satelliteapi/version'

module SatelliteApi
  # @summary Represents the API for a satellite instance.
  class Api
    attr_accessor :verbose # :Boolean
    attr_accessor :username, :password, :katello_url, :api_url, :instance_url # :String
    attr_accessor :verify_ssl # :Integer

    # @param username [String] API username
    # @param password [String] API password
    # @param instance_url [String] The base url of the satellite server
    # @param verbose [Boolean] If set to true, enables extra debug output, specifically the url strings for requests.
    # @param verify_ssl [Integer] Defaults to OpenSSL::SSL::VERIFY_NONE (as many Satellite instances have self-signed
    #   certs). Set to something else to change SSL verification.
    # @rbs (String, String, String, verbose: ?Boolean) -> SatelliteApi
    def initialize(instance_url, username, password, verbose: false, verify_ssl: OpenSSL::SSL::VERIFY_NONE)
      # Ensure instance_url doesn't end with a trailing slash
      @instance_url = instance_url.chomp('/')
      @username = username
      @password = password
      @api_url = '/api'
      @katello_url = '/katello/api'
      @verbose = verbose
      @verify_ssl = verify_ssl
    end

    # Sends the given request
    #
    # @param method [Symbol] Can be a :get, :post, :delete, :put, or any other HTTP request method.
    # @param url [String] The url to add to the base_url of the api.
    # @param payload [Hash] Optional, the payload to send.
    def request(method, url, payload: nil)
      puts "#{method.to_s.upcase}: #{instance_url + url}" if @verbose
      puts "Payload: #{JSON.pretty_generate(payload)}" if @verbose && !payload.nil?
      response = RestClient::Request.execute(
        method: method,
        url: instance_url + url,
        user: @username,
        password: @password,
        verify_ssl: @verify_ssl,
        headers: { accept: :json,
                   content_type: :json },
        payload: JSON.generate(payload)
      )
      JSON.parse(response.to_str)
    end

    # Performs a GET by using the passed URL location.
    #
    # @param request [String] The `url` request, such as `/content_views?noncomposite=true`
    # @param katello [Boolean] If true, uses the katello api rather than the base Satellite api
    # @return [Hash] the parsed response.
    # @rbi (String, katello: ?Boolean) -> untyped
    def get(request, katello: false)
      url_base = katello ? @katello_url : @api_url
      url = url_base + request
      request(:get, url)
    end

    # Performs a DELETE by using the passed URL location.
    # # @param request [String] The `url` request, such as `/content_views?noncomposite=true`
    # @param katello [Boolean] If true, uses the katello api rather than the base Satellite api
    # @return [Hash] the parsed response.
    # @rbi (String, ?Boolean katello) -> untyped
    def delete(request, katello: false)
      url_base = katello ? @katello_url : @api_url
      url = url_base + request
      pp url
      request(:delete, url)
    end

    # Performs a POST and passes the data to the URL location
    #
    # @param request [String] The `url` request, such as `/content_views?noncomposite=true`
    # @param payload [Hash] The payload as a hash.
    # @param katello [Boolean] if true, uses the katello api rather than the base Satellite api
    # @return [Hash] the parsed response
    # @rbi (String, Hash, ?Boolean katello) -> untyped
    def post(request, payload, katello: false)
      url_base = katello ? @katello_url : @api_url
      url = url_base + request
      request(:post, url, payload: payload)
    end

    # Performs a PUT and passes the data to the URL location
    #
    # @param request [String] The `url` request, such as `/content_views?noncomposite=true`
    # @param payload [Hash] The payload as a hash.
    # @param katello [Boolean] if true, uses the katello api rather than the base Satellite api
    # @return [Hash] the parsed response
    # @rbi (String, Hash, ?Boolean katello) -> untyped
    def put(request, payload, katello: false)
      url_base = katello ? @katello_url : @api_url
      url = url_base + request
      request(:put, url, payload: payload)
    end

    # Performs a GET by using the passed URL request, with the katello api
    #
    # @param request The `url` request, such as `/content_views?noncomposite=true`
    # @return [Hash] the parsed response
    # @rbi (String) -> untyped
    def get_katello(request)
      get(request, katello: true)
    end

    # Performs a POST and passes the data to the URL location with the katello api
    #
    # @param request [String] the `url` request, such as `/content_views?noncomposite=true`
    # @param payload [Hash] The payload as a hash.
    # @return [Hash] the parsed response
    # @rbi (String, Hash) -> untyped
    def post_katello(request, payload)
      post(request, payload, katello: true)
    end

    # Performs a PUT and passes the data to the URL location with the katello api
    #
    # @param request [String] the `url` request, such as `/content_views?noncomposite=true`
    # @param payload [Hash] The payload as a hash.
    # @return [Hash] the parsed response
    # @rbi (String, Hash) -> untyped
    def put_katello(request, payload)
      put(request, payload, katello: true)
    end

    # Performs a DELETE and passes the data to the URL location with the katello api
    #
    # @param request [String] the `url` request, such as `/content_views?noncomposite=true`
    # @return [Hash] the parsed response
    # @rbi (String) -> untyped
    def delete_katello(request)
      delete(request, katello: true)
    end
  end

  # @summary Represents the Satellite instance, for more "structured" interactions.
  class Instance
    attr_accessor :api # SatelliteApi

    # @param username [String] API username
    # @param password [String] API password
    # @param instance_url [String] The base url of the satellite server
    # @param verbose [Boolean] If set to true, enables extra debug output, specifically the url strings for requests.
    # @param verify_ssl [Integer] Defaults to OpenSSL::SSL::VERIFY_NONE (as many Satellite instances have self-signed
    #   certs). Set to something else to change SSL verification.
    # @rbs (String, String, String, verbose: ?Boolean) -> SatelliteApi
    def initialize(instance_url, username, password, verbose: false, verify_ssl: OpenSSL::SSL::VERIFY_NONE)
      @api = Api.new(instance_url, username, password, verbose: verbose, verify_ssl: verify_ssl)
    end

    # @param search [String] The search string, spaces will be replaced with +.
    # @return [Hash] Results hash from the search.
    def hosts(search = '')
      if search.empty?
        @api.get('/hosts?per_page=1000')
      else
        @api.get("/hosts?search=#{search.gsub!(' ', '+')}&per_page=1000")
      end
    end
  end
end
