# Organization section of the Meraki Dashboard API
# @author Joe Letizia
module Organizations
  # Returns information about an organization
  # @param [String] org_id dashboard organization ID
  # @return [Hash] results contains the org  id and name of the given organization
  def get_organization(org_id)
    self.make_api_call("/organizations/#{org_id}", 'GET')
  end

  # Returns the current license state for a given organization
  # @param [String] org_id dashboard organization ID
  # @return [Hash] results contains the current license state information
  def get_license_state(org_id)
    self.make_api_call("/organizations/#{org_id}/licenseState", 'GET')
  end

  # Returns the current inventory for an organization
  # @param [String] org_id dashboard organization ID
  # @return [Array] an array of hashes containg information on each individual device
  def get_inventory(org_id)
    self.make_api_call("/organizations/#{org_id}/inventory", 'GET')
  end

  # Returns the current SNMP status for an organization
  # @param [String] org_id dashboard organization ID
  # @return [Hash] a hash containing all SNMP configuration information for an organization
  def get_snmp_status(org_id)
    self.make_api_call("/organizations/#{org_id}/snmp", 'GET')
  end

  # Returns the configurations for an organizations 3rd party VPN peers
  # @param [String] org_id dashboard organization ID
  # @return [Array] an arrry of hashes containing the configuration information
  #   for each 3rd party VPN peer
  def get_third_party_peers(org_id)
    self.make_api_call("/organizations/#{org_id}/thirdPartyVPNPeers", 'GET')
  end
end
