# Switchports section of the Meraki Dashboard API
# @author Joe Letizia
module Switchports
  # Get configuration for all switchports on a given switch
  # @param [String] device_serial meraki serial number of the switch
  # @return [Array] an array of Hashes, each containing the switchports attributes / configuration
  def get_switch_ports(device_serial)
    make_api_call("/devices/#{device_serial}/switchPorts", 'GET')
  end

  # Get configuration for a single switch port
  # @param [String] device_serial meraki serial number of the switch
  # @param [Integer] port_number port number you want to modify
  # @return [Hash] hash of the switch ports attributes
  def get_single_switch_port(device_serial, port_number)
    raise 'Invalid switchport provided' unless port_number.is_a?(Integer)

    make_api_call("/devices/#{device_serial}/switchPorts/#{port_number}", 'GET')
  end

  # Update the attributes for a given switchport
  # @param [String] device_serial meraki serial number of the switch
  # @param [Integer] port_number port number you want to modify
  # @param [Hash] options hash of attributes. Keys can include name, tags, enabled, type, vlan, voiceVlan
  #   allowedVlans, poeEnabled, isolationEnabled, rstpEnabled, stpGuard, accessPolicyNumber. For values to these keys, please refer to the official Meraki Dashboard API documentation.
  # @return [Hash] hash of the update port attributes
  def update_switchport(device_serial, port_number, options)
    raise 'Options were not passed as a Hash' unless options.is_a?(Hash)
    raise 'Invalid switchport provided' unless port_number.is_a?(Integer)

    make_api_call("/devices/#{device_serial}/switchPorts/#{port_number}", 'PUT', options)
  end
end
