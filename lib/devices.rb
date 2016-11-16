module Devices
  # List all devices in a given network
  # @param [String] network_id network that you want to get devices for
  # @return [Array] array of hashes containing device information for all devices in the network
  def list_devices_in_network(network_id)
    self.make_api_call("/networks/#{network_id}/devices", 'GET')
  end

  # Device information for a specified device
  # @param [String] network_id the network id where the device exists
  # @param [String] device_serial the meraki serial number of the device you want to get
  #   information for
  # @return [Hash] a hash containing all of the devices attributes
  def get_single_device(network_id, device_serial)
    self.make_api_call("/networks/#{network_id}/devices/#{device_serial}", 'GET')
  end

  # Uplink information for a specified device
  # @param [String] network_id network id where the device exists
  # @param [String] device_serial meraki serial number of the device you want to check
  # @return [Array] an array of hashes for each uplink and it's attributes
  def get_device_uplink_stats(network_id, device_serial)
    self.make_api_call("/networks/#{network_id}/devices/#{device_serial}/uplink", 'GET')
  end

  # Update a single devices attributes
  # @param [String] network_id dashboard network id where the device exists
  # @param [String] device_serial meraki serial number of the device you want to modify
  # @param [Hash] options hash containing the attributes you want to modify.
  #   such as name, tags, longitude, latitude. A full list is found on the official Meraki API Docs
  # @return [Hash] a hash containing the devices new attribute set
  def update_device_attributes(network_id, device_serial, options)
    raise 'Options were not passed as a Hash' if !options.is_a?(Hash)
    options = {:body => options}
    self.make_api_call("/networks/#{network_id}/devices/#{device_serial}", 'PUT', options)
  end

  # Claim a single device into a network
  # @param [String] network_id dashboard network id to claim device into
  # @param [Hash] options hash containing :serial => 'meraki device SN' you want to claim
  # @return [Integer] code returns the HTTP code of the API call
  def claim_device_into_network(network_id, options)
    raise 'Options were not passed as a Hash' if !options.is_a?(Hash)
    options = {:body => options}
    self.make_api_call("/networks/#{network_id}/devices/claim", 'POST', options) 
  end

  # Remove a single device from a network
  # @param [String] network_id dashboard network id to remove device from
  # @param [String] serial meraki serial number for device to remove
  # @return [Integer] http_code HTTP code for API call
  def remove_device_from_network(network_id, device_serial)
    self.make_api_call("/networks/#{network_id}/devices/#{device_serial}/remove", 'POST')
  end
end
