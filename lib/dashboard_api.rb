require 'httparty'
require 'json'
require_relative 'organizations.rb'
# Ruby Implementation of the Meraki Dashboard api
# @author Joe Letizia
class DashboardAPI
  include HTTParty
  include Organizations
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
  def make_api_call(endpoint_url=nil)
    headers = {"X-Cisco-Meraki-API-Key" => @key}
    options = {:headers => headers}
    res = HTTParty.get("#{self.class.base_uri}/#{endpoint_url}", options)
    return JSON.parse(res.body)
  end
end
