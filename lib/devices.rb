# frozen_string_literal: true

# Devices section of the Meraki Dashboard API
# @author Joe Letizia, Shane Short
module Devices
  # List all devices in a given network
  # @param [String] network_id network that you want to get devices for
  # @return [Array] array of hashes containing device information for all devices in the network
  def list_devices_in_network(network_id)
    make_api_call("/networks/#{network_id}/devices", :get)
  end

  # List all devices in a given organization
  # @param [String] org_id the organization that has the devices claimed.
  # @return [Array] array of hashes containing device information for all devices in the org.
  def list_devices_for_organization(org_id)
    make_api_call("/organizations/#{org_id}/devices", :get)
  end

  # Device information for a specified device
  # @param [String] _network_id the network id where the device exists
  # @param [String] device_serial the meraki serial number of the device you want to get
  #   information for
  # @return [Hash] a hash containing all of the devices attributes
  # Note: Deprecated, please use get_device
  def get_single_device(_network_id, device_serial)
    get_device(device_serial)
  end

  # Device information for a specified device
  # @param [String] device_serial: the meraki serial number of the device you want to get
  #   information for
  # @return [Hash] a hash containing all of the devices attributes
  def get_device(device_serial)
    make_api_call("/devices/#{device_serial}", :get)
  end

  # Update a specific device
  # @param [String] device_serial: the serial number of the device you wish to update
  # @param [Hash] options: a hash containing the attributes of the device
  # additional details on accepted fields can be found in the official Meraki API Documentation (https://developer.cisco.com/meraki/api-v1/#!update-device)
  # @return [Hash] A hash with the devices full attributes after the operation has completed
  def update_device(device_serial, options)
    raise 'Options were not passed as a Hash' unless options.is_a?(Hash)

    make_api_call("/devices/#{device_serial}", :put, options)
  end

  # Uplink information for a specified device
  # @param [String] network_id network id where the device exists
  # @param [String] device_serial meraki serial number of the device you want to check
  # @return [Array] an array of hashes for each uplink and it's attributes
  # @deprecated Please use get_organisation_device_uplinks
  def get_device_uplink_stats(network_id, device_serial, organization_id: nil)
    if organization_id.nil?
      organization_id = get_network(network_id)&.dig('organizationId')
    end

    get_organization_uplink_stats(organization_id, networks: [network_id])&.detect { |device| device['serial'] == device_serial }&.dig('uplinks')
  end

  # Uplink information for a specified device
  # @param [String] organization_id organization where the uplinks exist
  # @param [Array] networks: an array of network ids to get uplink stats for
  # @return [Array] an array of hashes for each device and it's uplink attributes
  def get_organization_uplink_stats(organization_id, networks: [])
    options = {}
    options[:networkIds] = networks if networks.any?

    make_api_call("/organizations/#{organization_id}/appliance/uplink/statuses", :get, options)
  end

  # Update a single devices attributes
  # @param [String] _network_id dashboard network id where the device exists (deprecated)
  # @param [String] device_serial meraki serial number of the device you want to modify
  # @param [Hash] options hash containing the attributes you want to modify.
  #   such as name, tags, longitude, latitude. A full list is found on the official Meraki API Docs
  # @return [Hash] a hash containing the devices new attribute set
  def update_device_attributes(_network_id, device_serial, options)
    raise 'Options were not passed as a Hash' unless options.is_a?(Hash)

    make_api_call("/devices/#{device_serial}", :put, options)
  end

  # Get a devices management interface information
  # @param [String] device_serial meraki serial number of the device you want to check
  # @return [Hash] a hash containing the management information for each wan port on the device
  def get_device_management_interface(device_serial)
    make_api_call("/devices/#{device_serial}/managementInterface", :get)
  end

  # Set a devices management interface information
  # @param [String] device_serial meraki serial number of the device you want to check
  # @param [Hash] options hash containing the attributes you want to modify.
  #   such as vlan, IP settings or dns. A full list is found on the official Meraki API Docs
  # @return [Hash] a hash containing the management information for each wan port on the device
  def update_device_management_interface(device_serial, options)
    raise 'Options were not passed as a Hash' unless options.is_a?(Hash)

    make_api_call("/devices/#{device_serial}/managementInterface", :put, options)
  end

  # Claim a single device into a network
  # @param [String] network_id dashboard network id to claim device into
  # @param [Hash] options hash containing :serial => 'meraki device SN' you want to claim
  # @return [Integer] code returns the HTTP code of the API call
  def claim_device_into_network(network_id, options)
    raise 'Options were not passed as a Hash' unless options.is_a?(Hash)

    make_api_call("/networks/#{network_id}/devices/claim", :post, options)
  end

  # Remove a single device from a network
  # @param [String] network_id dashboard network id to remove device from
  # @param [String] device_serial meraki serial number for device to remove
  # @return [Integer] http_code HTTP code for API call
  def remove_device_from_network(network_id, device_serial)
    options = { serial: device_serial }
    make_api_call("/networks/#{network_id}/devices/remove", :post, options)
  end
end