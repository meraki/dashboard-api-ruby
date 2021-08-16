# frozen_string_literal: true

# Networks section of the Meraki Dashboard API
# @author Joe Letizia
module Networks
  # Returns the list of networks for a given organization
  # @param [String] org_id dashboard organization ID
  # @return [Array] an array of hashes containing the network details
  def get_networks(org_id)
    make_api_call("/organizations/#{org_id}/networks", :get)
  end

  # Returns the network details for a single network
  # @param [String] network_id dashboard network ID
  # @return [Hash] a hash containing the network details of the specific network
  def get_single_network(network_id)
    make_api_call("/networks/#{network_id}", :get)
  end

  # Updates a network's details
  # @param [String] network_id dashboard network ID
  # @param [Hash] options a hash containing any of the following keys:
  #   name: the network name
  #   tags: tags assigned to the network
  # @return [Hash] a hash containing the updated network details
  def update_network(network_id, options)
    raise 'Options were not passed as a Hash' unless options.is_a?(Hash)

    make_api_call("/networks/#{network_id}", :put, options)
  end

  # Create a new Dashboard network
  # @param [String] org_id dashboard organization ID
  # @param [Hash] options a hash containing the following options:
  #   name: the network name (REQUIRED)
  #   type: the type of network (wireless, switch, appliance, or phone) (REQUIRED)
  #   tags: tags for the network (NOT REQUIRED)
  # @return [Hash] a hash containing the new networks details
  def create_network(org_id, options)
    raise 'Options were not passed as a Hash' unless options.is_a?(Hash)

    make_api_call("/organizations/#{org_id}/networks", :post, options)
  end

  # Create a new Dashboard network
  # @param [String] org_id dashboard organization ID
  # @param [Hash] options a hash containing the following options:
  #   name: the network name (REQUIRED)
  #   type: the type of network (wireless, switch, appliance, or phone) (REQUIRED)
  #   tags: tags for the network (NOT REQUIRED)
  # @return [Hash] a hash containing the new networks details
  def create_v1_network(org_id, options)
    raise 'Options were not passed as a Hash' unless options.is_a?(Hash)

    make_v1_api_call("/organizations/#{org_id}/networks", :post, options)
  end

  # Delete an existing Dashboard network
  # @param [String] network_id dashboard netwok ID to delete
  # @return [Bool] status true if the network was deleted, false if not
  def delete_network(network_id)
    res = make_api_call("/networks/#{network_id}", :delete)
    res.code == 204
  end

  # Combine multiple networks into a singular network
  # @param [Hash] options containing the following:
  # name              [String]: The name of the combined network
  # networkIds        [Array]: A list of the network IDs that will be combined. If an ID of a combined network is
  #                   included in this list, the other networks in the list will be grouped into that network
  # enrollmentString  [String] (optional): A unique identifier which can be used for device enrollment or easy access
  #                   through the Meraki SM Registration page or the Self Service Portal.
  #                   Please note that changing this field may cause existing bookmarks to break. All networks that are
  #                   part of this combined network will have their enrollment string appended by '-network_type'.
  #                   If left empty, all exisitng enrollment strings will be deleted.
  def combine_network(org_id, options)
    raise 'Options were not passed as a Hash' unless options.is_a?(Hash)

    make_v1_api_call("organizations/#{org_id}/networks/combine")
  end

  # Get AutoVPN settings for a specific network
  # @param [String] network_id dashboard network ID to get AutoVPN settings for
  # @return [Hash] a hash containing the AutoVPN details for the network
  def get_auto_vpn_settings(network_id)
    make_api_call("/networks/#{network_id}/siteToSiteVpn", :get)
  end

  # Update AutoVPN for a specific network
  # @param [String] network_id dashboard network ID to update AutoVPN settings for
  # @param [Hash] options options hash containing the following options:
  #   mode: hub, spoke or none
  #   hubs: an array of Hashes containing the hubId and a true or false for useDefaultRoute
  #   subnets: an array of Hashes containing localSubnet and useVPN
  # @return [Hash]
  def update_auto_vpn_settings(network_id, options)
    raise 'Options were not passed as a Hash' unless options.is_a?(Hash)

    make_api_call("/networks/#{network_id}/siteToSiteVpn", :put, options)
  end

  # Get all MS access policies configured for a specific Dashboard network
  # @param [String] network_id dashboard network ID to get MS policies for
  # @return [Array] an array of hashes for containing the policy information
  def get_ms_access_policies(network_id)
    make_api_call("/networks/#{network_id}/accessPolicies", :get)
  end

  # Get all group policies configured for a specific Dashboard network
  # @param [String] network_id dashboard network ID to get group policies for
  # @return [Array] an array of hashes for containing the policy information
  def get_group_access_policies(network_id)
    make_api_call("/networks/#{network_id}/groupPolicies", :get)
  end

  # Create a group access policy for a network
  # @param [String] network_id the source network that you want to bind to a tempalte
  # @param [Hash] options options hash that contains group policy values. Refer to the official
  #   Meraki Dashboard API documentation for more information on these.
  # @return [Integer] HTTP Code
  def create_group_access_policy(network_id, options)
    raise 'Options were not passed as a Hash' unless options.is_a?(Hash)

    make_api_call("/networks/#{network_id}/groupPolicies", :post, options)
  end

  # Bind a single network to a configuration template
  # @param [String] network_id the source network that you want to bind to a tempalte
  # @param [Hash] options options hash that contains configTemplateId and autoBind values. Refer to the official
  #   Meraki Dashboard API documentation for more information on these.
  # @return [Integer] HTTP Code
  def bind_network_to_template(network_id, options)
    raise 'Options were not passed as a Hash' unless options.is_a?(Hash)

    make_api_call("/networks/#{network_id}/bind", :post, options)
  end

  # Unbind a single network from a configuration template
  # @param [String] network_id the network that you want to unbind from it's template
  # @return [Integer] HTTP Code
  def unbind_network_to_template(network_id)
    make_api_call("/networks/#{network_id}/unbind", :post)
  end

  # Return traffic analysis data for a network
  # @param [String] network_id network that you want data for
  # @param [Hash] options options hash containing a timespan and deviceType. Refer to the official
  #   Meraki Dashboard API documentation for more information on these.
  def traffic_analysis(network_id, options)
    raise 'Options were not passed as a Hash' unless options.is_a?(Hash)

    make_api_call("/networks/#{network_id}/traffic", :get, options)
  end
end
