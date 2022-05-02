# frozen_string_literal: true

require 'httparty'
require 'nitlink/response'
require 'json'
require_relative 'dashboard-api/version'
require 'organizations'
require 'networks'
require 'admins'
require 'devices'
require 'templates'
require 'clients'
require 'ssids'
require 'vlans'
require 'switchports'
require 'switch_profiles'
require 'saml'

# Ruby Implementation of the Meraki Dashboard api
# @author Joe Letizia, Shane Short
class DashboardAPI
  include HTTParty
  include Organizations
  include DashboardAPIVersion
  include Networks
  include Clients
  include Devices
  include SSIDs
  include Admins
  include Switchports
  include SwitchProfiles
  include VLANs
  include Templates
  include SAML

  base_uri 'https://api.meraki.com/api/v1'

  attr_reader :key
  attr_accessor :debug_enabled

  def initialize(key)
    @key = key
  end

  private
  # @private
  # @description Parse the response coming back from the API
  # @param [String] response_object: The Raw JSON response from the API
  # @return [Hash] The parsed JSON response
  def parse_response!(response_object)
    raise '404 returned. Are you sure you are using the proper IDs?' if response_object.code == 404

    begin
      response = JSON.parse(response_object.body)
      raise "Bad Request due to the following error(s): #{response['errors']}" if response.is_a?(Hash) && response['errors']

      response
    rescue JSON::ParserError
      response_object.code
    rescue TypeError
      response_object.code
    end
  end

  # @private
  # Dispatch a HTTP request to the API.
  # @param [String] endpoint_url: The API Endpoint
  # @param [Symbol] http_method: The HTTP Method
  # @param [Hash] options_hash: The options to be passed to the API
  # @param [String] base_uri: The base uri to be used for the request
  # @param [Integer] pages: The number of pages to be returned
  # @return [Hash] a hash of the JSON response
  def make_api_call(endpoint_url, http_method,
                    options_hash = {}, base_uri = nil,
                    pages = Float::INFINITY)
    options = {
      headers: { 'X-Cisco-Meraki-API-Key' => @key, 'Content-Type' => 'application/json' },
      body: options_hash.to_json
    }
    options[:base_uri] = base_uri if base_uri
    options[:debug_output] = $stdout if debug_enabled

    case http_method
    when :get
      resource = DashboardAPI.send(http_method, endpoint_url, options)
      object = parse_response!(resource)
      if object.is_a? Array
        page_count = 1
        response_object = []
        response_object.concat(object)
        while (next_page = resource.links&.by_rel('next')&.target) && page_count <= pages
          resource = DashboardAPI.send(http_method, next_page, options)
          response_object.concat(parse_response!(resource))
        end
        response_object
      else
        object
      end
    when :post, :put, :delete
      res = DashboardAPI.send(http_method, endpoint_url, options)
      parse_response!(res)
    else
      raise 'Invalid HTTP Method. Only GET, POST, PUT and DELETE are supported.'
    end
  end
end
