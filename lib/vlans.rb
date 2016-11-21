# VLANs section of the Meraki Dashboard API
# @author Joe Letizia
module VLANs
  # Returns a list of the configured VLANs in a Dashboard network
  # @param [String] network_id the network ID you want the VLANs for
  # @return [Array] an array of hashes containing each VLAN and it's attributes
  def list_vlans(network_id)
    self.make_api_call("/networks/#{network_id}/vlans", 'GET')
  end
 
  # Return a single configured VLAN for a network
  # @param [String] network_id the network ID the VLAN exists in
  # @param [Integer] vlan_id the VLAN ID you want the attributes for
  # @return [Hash] a hash of the VLAN's attributes 
  def return_vlan(network_id, vlan_id)
    self.make_api_call("/networks/#{network_id}/vlans/#{vlan_id}", 'GET')
  end

  # Add a single VLAN to a network
  # @param [String] network_id the network you want to add a VLAN to
  # @param [Hash] options a hash containing the attributes of id, name, subnet and applianceIp
  #   additional details on these can be found in the official Meraki API Documentation
  # @return [Hash] the attributes of the newly created vlan
  def add_vlan(network_id, options)
    raise 'Options were not passed as a Hash' if !options.is_a?(Hash)
    
    self.make_api_call("/networks/#{network_id}/vlans", 'POST', options)
  end

  # Update the attributes for a single VLAN
  # @param [String] network_id the network ID for the VLAN you want to update
  # @param [Integer] vlan_id the VLAN ID you want to update
  # @param [Hash] options a hash containing the attributes of name, subnet and applianceIp.
  #   additional details on these can be found in the official Meraki API Documentation
  # @return [Hash] the updated attributes for the VLAN
  def update_vlan(network_id, vlan_id, options)
    raise 'Options were not passed as a Hash' if !options.is_a?(Hash)
    
    self.make_api_call("/networks/#{network_id}/vlans/#{vlan_id}", 'PUT', options)
  end

  # Delete a single vlan
  # @param [String] network_id the Network ID for the VLAN you want to delete
  # @param [Integer] vlan_id the VLAN ID you want to delete
  # @return [Integer] code HTTP return code
  def delete_vlan(network_id, vlan_id)
    self.make_api_call("/networks/#{network_id}/vlans/#{vlan_id}", 'DELETE')
  end
end
