# SSIDs section of the Meraki Dashboard API
# @author Joe Letizia
module SSIDs
  # Get a list of the SSIDs and their attributes for a network
  # @param [String] network_id network id where the SSIDs you exists are
  # @return [Array] an array of Hashes containing the SSID attributes
  def list_ssids_in_network(network_id)
    make_api_call("/networks/#{network_id}/ssids", 'GET')
  end

  # Get the attributes for a single SSID
  # @param [String] network_id network id where the SSID you want to list is
  # @param [Integer] ssid_number the SSID number you want to change. Range is from 0-14
  # @return [Hash] the attributes for the requested SSID
  def get_single_ssid(network_id, ssid_number)
    raise 'Please provide a valid SSID number' unless ssid_number.is_a?(Integer) && ssid_number <= 14

    make_api_call("/networks/#{network_id}/ssids/#{ssid_number}", 'GET')
  end

  # Update the attributes for a single SSID
  # @param [String] network_id network id where the SSID you want to change is
  # @param [Integer] ssid_number the SSID number you want to change. Range is from 0-14
  # @param [Hash] options hash containing the attributes to update. Can include name, enabled, authMode, encryptionMode and psk
  # @return [Hash] the updated attributes for the SSID
  def update_single_ssid(network_id, ssid_number, options)
    raise 'Options were not passed as a Hash' unless options.is_a?(Hash)
    raise 'Please provide a valid SSID number' unless ssid_number.is_a?(Integer) && ssid_number <= 14

    make_api_call("/networks/#{network_id}/ssids/#{ssid_number}", 'PUT', options)
  end
end
