require 'rest-client'

class APIClient
  def initialize(base_url, api_key)
    @base_url, @api_key = base_url, api_key
  end

  def make_api_call(http_method, endpoint_url, options = {})
    headers = {'X-Cisco-Meraki-API-key': @api_key, 'Content-Type' => 'application/json'}
    begin
      case http_method.upcase
      when 'GET'
        response = RestClient.get("#{@base_url}/#{endpoint_url}", headers)
      end
    rescue RestClient::ExceptionWithResponse => e
      puts e
    end
  end
end
