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
require 'phones'
require 'ssids'
require 'vlans'
require 'switchports'
require 'saml'

# Ruby Implementation of the Meraki Dashboard api
# @author Joe Letizia
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
  include VLANs
  include Phones
  include Templates
  include SAML

  base_uri 'https://dashboard.meraki.com/api/v0'
  debug_output $stdout

  attr_reader :key

  def initialize(key)
    @key = key
  end

  def parse_response!(response_object)
    raise '404 returned. Are you sure you are using the proper IDs?' if response_object.code == 404

    begin
      response = JSON.parse(response_object.body)
      raise "Bad Request due to the following error(s): #{response['errors']}" if response['errors']

      response
    rescue JSON::ParserError
      response_object.code
    rescue TypeError
      response_object.code
    end
  end

  # @private
  # Inner function, not to be called directly
  # Utility wrapper to make calls to v1 api endpoints easier in the code
  def make_v1_api_call(url, method, options = {})
    make_api_call(url, method, options, 'https://dashboard.meraki.com/api/v1')
  end

  # @private
  # Inner function, not to be called directly
  # @todo Eventually this will need to support POST, PUT and DELETE. It also
  #   needs to be a bit more resillient, instead of relying on HTTParty for exception
  #   handling
  def make_api_call(endpoint_url, http_method, options_hash = {}, base_uri_override = nil)
    headers = { 'X-Cisco-Meraki-API-Key' => @key, 'Content-Type' => 'application/json' }

    options = { headers: headers, body: options_hash.to_json }
    options[:base_uri] = base_uri_override unless base_uri_override.nil?
    case http_method
    when 'GET'
      res = DashboardAPI.get(endpoint_url, options)
      obj = parse_response!(res)

      if obj.is_a? Array
        response_object = []
        response_object.concat(obj)
        while (next_page = res.links&.by_rel('next')&.target)
          res = DashboardAPI.get(next_page, options)
          response_object.concat(parse_response!(res))
        end
        response_object
      else
        obj
      end

    when 'POST'
      res = DashboardAPI.post(endpoint_url, options)
      parse_response!(res)
    when 'PUT'
      res = DashboardAPI.put(endpoint_url, options)
      parse_response!(res)
    when 'DELETE'
      res = DashboardAPI.delete(endpoint_url, options)
      parse_response!(res)
    else
      raise 'Invalid HTTP Method. Only GET, POST, PUT and DELETE are supported.'
    end
  end
end
