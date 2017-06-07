require 'json'

class API
  # read in the current structure of the Dashboard API
  @api_data = JSON.parse(File.read('api_data/api_struct.json'))

  def initialize
    # do nothing
  end

  # For every API section, go through each of the API calls defined in the JSON
  # and create a method for it.
  # The argument list is dynamically generated based off of the "path" section
  # of each API call defined in the JSON file.
  @api_data.each do |api_section, api_data|
    api_data.each do |api_call|
      args = api_call['path'].scan(/(?<=\[)\w+(?=\])/)
      method_name = "#{api_section.downcase.gsub(' ', '_')}_#{api_call['action_name']}"

      class_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{method_name}(#{args.join(', ')})
          # method body
        end
      EOS

    end
  end

end



puts API.instance_methods
api = API.new
#api.admins_update()
#api.admins_index()
#api.networks_index({})
