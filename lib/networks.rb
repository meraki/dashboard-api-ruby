# Networks section of the Meraki Dashboard API
# @author Joe Letizia
module Networks
  # Returns the list of networks for a given organization
  # @param [String] org_id dashboard organization ID
  # @return [Array] an array of hashes containing the network details
  def get_networks(org_id)
    self.make_api_call("/organizations/#{org_id}/networks", 'GET')
  end

  # Returns the network details for a single network
  # @param [String] network_id dashboard network ID
  # @return [Hash] a hash containing the network details of the specific network
  def get_single_network(network_id)
    self.make_api_call("/networks/#{network_id}", 'GET')
  end

  # Updates a network's details
  # @param [String] network_id dashboard network ID
  # @param [Hash] options a hash containing any of the following keys:
  #   name: the network name
  #   tags: tags assigned to the network
  # @return [Hash] a hash containing the updated network details
  def update_network(network_id, options)
    raise 'Options were not passed as a Hash' if !options.is_a?(Hash)
    options = {:body => options}
    self.make_api_call("/networks/#{network_id}",'PUT', options)
  end

  # Create a new Dashboard network
  # @param [String] org_id dashboard organization ID
  # @param [Hash] options a hash containing the following options:
  #   name: the network name (REQUIRED)
  #   type: the type of network (wireless, switch, appliance, or phone) (REQUIRED)
  #   tags: tags for the network (NOT REQUIRED)
  # @return [Hash] a hash containing the new networks details
  def create_network(org_id, options)
    raise 'Options were not passed as a Hash' if !options.is_a?(Hash)
    options = {:body => options}
    self.make_api_call("/organizations/#{org_id}/networks", 'POST', options)
  end

  # Delete an existing Dashboard network
  # @param [String] network_id dashboard netwok ID to delete
  # @return [Bool] status true if the network was deleted, false if not
  def delete_network(network_id)
    res = self.make_api_call("/networks/#{network_id}", 'DELETE')
    return res.code == 204 ? true : false
  end

  # Get AutoVPN settings for a specific network
  # @param [String] network_id dashboard network ID to get AutoVPN settings for
  # @return [Hash] a hash containing the AutoVPN details for the network
  def get_auto_vpn_settings(network_id)
    res = self.make_api_call("/networks/#{network_id}/siteToSiteVpn", 'GET')
  end

  # Update AutoVPN for a specific network
  # @param [String] network_id dashboard network ID to update AutoVPN settings for
  # @param [Hash] options options hash containing the following options:
  #   mode: hub, spoke or none
  #   hubs: an array of Hashes containing the hubId and a true or false for useDefaultRoute
  #   subnets: an array of Hashes containing localSubnet and useVPN
  # @return [Hash]
  def update_auto_vpn_settings(network_id, options)
    raise 'Options were not passed as a Hash' if !options.is_a?(Hash)

    options = {:body => options}
    res = self.make_api_call("/networks/#{network_id}/siteToSiteVpn", 'PUT', options)
  end

  # Get all MS access policies configured for a specific Dashboard network
  # @param [String] network_id dashboard network ID to get MS policies for
  # @return [Array] an array of hashes for containing the policy information
  def get_ms_access_policies(network_id)
    res = self.make_api_call("/networks/#{network_id}/accessPolicies", 'GET')
    return res
  end

  # Bind a single network to a configuration template
  # @param [String] network_id the source network that you want to bind to a tempalte
  # @param [Hash] options options hash that contains configTemplateId and autoBind values. Refer to the official
  #   Meraki Dashboard API documentation for more information on these.
  # @return [Integer] HTTP Code
  def bind_network_to_template(network_id, options)
    raise 'Options were not passed as a Hash' if !options.is_a?(Hash)
    options = {:body => options}

    self.make_api_call("/networks/#{network_id}/bind", 'POST', options)
  end

  # Unbind a single network from a configuration template
  # @param [String] network_id the network that you want to unbind from it's template
  # @return [Integer] HTTP Code
  def unbind_network_to_template(network_id)
    self.make_api_call("/networks/#{network_id}/unbind", 'POST')
  end

  # Return traffic analysis data for a network
  # @param [String] network_id network that you want data for
  # @param [Hash] options options hash containing a timespan and deviceType. Refer to the official
  #   Meraki Dashboard API documentation for more information on these.
  def traffic_analysis(network_id, options)
    raise 'Options were not passed as a Hash' if !options.is_a?(Hash)
    options = {:body => options}
    self.make_api_call("/networks/#{network_id}/traffic", 'GET', options)
  end
end
