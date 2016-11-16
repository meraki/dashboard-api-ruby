require 'httparty'
require 'json'
require_relative "dashboard-api/version"
require 'organizations'
require 'networks'
require 'clients'
# Ruby Implementation of the Meraki Dashboard api
# @author Joe Letizia
class DashboardAPI
  include HTTParty
  include Organizations
  include DashboardAPIVersion
  include Networks
  include Clients
  base_uri "https://dashboard.meraki.com/api/v0"

  attr_reader :key

  def initialize(key)
    @key = key
  end

  # @private
  # Inner function, not to be called directly
  # @todo Eventually this will need to support POST, PUT and DELETE. It also
  #   needs to be a bit more resillient, instead of relying on HTTParty for exception
  #   handling
  def make_api_call(endpoint_url, http_method, options_hash={})
    headers = {"X-Cisco-Meraki-API-Key" => @key, 'Content-Type' => 'application/json'}
    headers.merge!(options_hash[:headers]) if options_hash[:headers]

    options = {:headers => headers, :body => options_hash[:body].to_json}
    case http_method
    when 'GET'
      res = HTTParty.get("#{self.class.base_uri}/#{endpoint_url}", options)
      raise "404 returned. Are you sure you are using the proper IDs?" if res.code == 404
      return JSON.parse(res.body)
    when 'POST'
      res = HTTParty.post("#{self.class.base_uri}/#{endpoint_url}", options)
      raise "Bad Request due to the following error(s): #{res['errors']}" if res['errors']
      raise "404 returned. Are you sure you are using the proper IDs?" if res.code == 404
      return JSON.parse(res.body)
    when 'PUT'
      res = HTTParty.put("#{self.class.base_uri}/#{endpoint_url}", options)
      raise "Bad Request due to the following error(s): #{res['errors']}" if res['errors']
      raise "404 returned. Are you sure you are using the proper IDs?" if res.code == 404
      return JSON.parse(res.body)
    when 'DELETE'
      res = HTTParty.delete("#{self.class.base_uri}/#{endpoint_url}", options)
      raise "Bad Request due to the following error(s): #{res['errors']}" if res['errors']
      raise "404 returned. Are you sure you are using the proper IDs?" if res.code == 404
      return res
    else
      raise 'Invalid HTTP Method. Only GET, POST, PUT and DELETE are supported.'
    end
  end
end
