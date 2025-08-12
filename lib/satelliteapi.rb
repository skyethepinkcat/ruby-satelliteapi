# frozen_string_literal: true

require 'json'
require 'pp'
require 'rest-client'
require 'socket'

require_relative 'satelliteapi/version'

# module SatelliteApi
#  class Error < StandardError; end
# end

# Represents the API for a satellite instance.
class SatelliteApi
  attr_accessor :verbose # :Boolean

  attr_reader :katello_url, :url # :String

  # @param username [String] API username
  # @param password [String] API password
  # @param base_url [String] The base url of the satellite server
  # @param verbose [Boolean] If set to true, enables extra debug output, specifically the url strings for requests.
  # @rbs (String, String, String, verbose: ?Boolean) -> SatelliteApi
  def initialize(base_url, username, password, verbose: false)
    @username = username
    @password = password
    @api_url = "#{base_url}/api/v2"
    @katello_url = "#{base_url}/katello/api/"
    @verbose = verbose
  end

  # Performs a GET by using the passed URL location.
  #
  # @param request [String] The `url` request, such as `/content_views?noncomposite=true`
  # @param katello [Boolean] If true, uses the katello api rather than the base Satellite api
  # @return [Hash] the parsed response.
  # @rbi (String, katello: ?Boolean) -> untyped
  def get_json(request, katello: false)
    url_base = katello ? @katello_url : @api_url
    url = url_base + request
    puts url if @verbose
    response = RestClient::Request.execute(
      method: :get,
      url: url,
      user: @username,
      password: @password,
      verify_ssl: OpenSSL::SSL::VERIFY_NONE,
      headers: { accept: :json,
                 content_type: :json }
    )
    JSON.parse(response.to_str)
  end

  # Performs a DELETE by using the passed URL location.
  # # @param request [String] The `url` request, such as `/content_views?noncomposite=true`
  # @param katello [Boolean] If true, uses the katello api rather than the base Satellite api
  # @return [Hash] the parsed response.
  # @rbi (String, ?Boolean katello) -> untyped
  def delete_json(request, katello: false)
    url_base = katello ? @katello_url : @api_url
    url = url_base + request
    puts url if @verbose
    response = RestClient::Request.execute(
      method: :delete,
      url: url,
      user: @username,
      password: @password,
      verify_ssl: OpenSSL::SSL::VERIFY_NONE,
      headers: { accept: :json,
                 content_type: :json }
    )
    JSON.parse(response.to_str)
  end

  # Performs a POST and passes the data to the URL location
  #
  # @param request [String] The `url` request, such as `/content_views?noncomposite=true`
  # @param payload [Hash] The payload as a hash, which will be changed to JSON.
  # @param katello [Boolean] if true, uses the katello api rather than the base Satellite api
  # @return [Hash] the parsed response
  # @rbi (String, Hash, ?Boolean katello) -> untyped
  def post_json(request, payload, katello: false)
    url_base = katello ? @katello_url : @api_url
    url = url_base + request
    puts url if @verbose
    response = RestClient::Request.execute(
      method: :post,
      url: url,
      user: @username,
      password: @password,
      verify_ssl: OpenSSL::SSL::VERIFY_NONE,
      headers: { accept: :json,
                 content_type: :json },
      payload: payload.to_json
    )
    JSON.parse(response.to_str)
  end

  # Performs a PUT and passes the data to the URL location
  #
  # @param request [String] The `url` request, such as `/content_views?noncomposite=true`
  # @param payload [Hash] The payload as a hash, which will be changed to JSON.
  # @param katello [Boolean] if true, uses the katello api rather than the base Satellite api
  # @return [Hash] the parsed response
  # @rbi (String, JSON, ?Boolean katello) -> untyped
  def put_json(request, payload, katello: false)
    url_base = katello ? @katello_url : @api_url
    url = url_base + request
    puts url if @verbose
    response = RestClient::Request.execute(
      method: :put,
      url: url,
      user: @username,
      password: @password,
      verify_ssl: OpenSSL::SSL::VERIFY_NONE,
      headers: { accept: :json,
                 content_type: :json },
      payload: payload.to_json
    )
    JSON.parse(response.to_str)
  end

  # Performs a GET by using the passed URL request, with the katello api
  #
  # @param request The `url` request, such as `/content_views?noncomposite=true`
  # @return [Hash] the parsed response
  # @rbi (String) -> untyped
  def get_katello_json(request)
    get_json(request, katello: true)
  end

  # Performs a POST and passes the data to the URL location with the katello api
  #
  # @param request [String] the `url` request, such as `/content_views?noncomposite=true`
  # @param payload [Hash] The payload as a hash.
  # @return [Hash] the parsed response
  # @rbi (String, Hash) -> untyped
  def post_katello_json(request, payload)
    post_json(request, payload, katello: true)
  end

  # Performs a PUT and passes the data to the URL location with the katello api
  #
  # @param request [String] the `url` request, such as `/content_views?noncomposite=true`
  # @param payload [Hash] The payload as a hash.
  # @return [Hash] the parsed response
  # @rbi (String, Hash) -> untyped
  def put_katello_json(request, payload)
    put_json(request, payload, katello: true)
  end

  # Performs a DELETE and passes the data to the URL location with the katello api
  #
  # @param request [String] the `url` request, such as `/content_views?noncomposite=true`
  # @return [Hash] the parsed response
  # @rbi (String) -> untyped
  def delete_katello_json(request)
    delete_json(request, katello: true)
  end
end
