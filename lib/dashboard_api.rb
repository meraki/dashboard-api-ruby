require 'json'
require_relative './api_client.rb'

class DashboardAPI
  # read in the current structure of the Dashboard API
  @api_data = JSON.parse(File.read("#{__dir__}/api_data/api_struct.json"))

  def initialize(api_key)
    @api_client = APIClient.new('http://dashboard.meraki.com/api/v0', api_key)
  end

  # For every API section, go through each of the API calls defined in the JSON
  # and create a method for it.
  # The argument list is dynamically generated based off of the "path" section
  # of each API call defined in the JSON file.
  @api_data.each do |api_section, api_data|
    api_data.each do |api_call|
      args = api_call['path'].scan(/(?<=\[)\w+(?=\])/)
      method_name = "#{api_section.downcase.gsub(' ', '_')}_#{api_call['action_name']}"
      # convert the [ ] syntax from the JSON blob to #{} ruby syntax for
      # interpolation below
      endpointurl = api_call['path'].gsub('[', '#{').gsub(']', '}')
      class_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{method_name}(#{args.join(', ')})
          @api_client.make_api_call("#{api_call['http_method']}", "#{endpointurl}")
        end
      EOS

    end
  end

end
