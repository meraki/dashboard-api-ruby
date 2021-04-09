# SAML section of the Meraki Dashboard API
# @author Joe Letizia
module SAML
  # List all SAML roles defined on an organization
  # @param [String] org_id organization ID you want the SAML roles from
  # @return [Array] an array of hashes containing each SAML role and it's attributes
  def list_saml_roles(org_id)
    make_api_call("/organizations/#{org_id}/samlRoles", 'GET')
  end

  # Create a new SAML role on an organization
  # @param [String] org_id organization ID you want to create the SAML roles on
  # @param [Hash] options an options hash containing the attributes for the SAML role. Can include role, orgAccess, tags, and networks.
  #   Refer to the Meraki Dashboard API for more information on these tags
  # @return [Hash] returns the newly created SAML role
  def create_saml_role(org_id, options)
    make_api_call("/organizations/#{org_id}/samlRoles", 'POST', options)
  end

  # Update an existing SAML role on an organization
  # @param [String] org_id organization ID you want to update the SAML roles on
  # @param [String] saml_id the ID of the SAML role that you want to update
  # @param [Hash] options an options hash containing the attributes for the SAML role. Can include role, orgAccess, tags, and networks.
  #   Refer to the Meraki Dashboard API for more information on these tags
  # @return [Hahs] returns the updated SAML role
  def update_saml_role(org_id, saml_id, options)
    make_api_call("/organizations/#{org_id}/samlRoles/#{saml_id}", 'PUT', options)
  end

  # Return a single SAML role
  # @param [String] org_id organization ID you want to return the SAML roles on
  # @param [String] saml_id the ID of the SAML role that you want to return
  # @return [Hash] returns the request SAML role
  def return_saml_role(org_id, saml_id)
    make_api_call("/organizations/#{org_id}/samlRoles/#{saml_id}", 'GET')
  end

  # Remove a single SAML role
  # @param [String] org_id organization ID you want to remove the SAML roles on
  # @param [String] saml_id the ID of the SAML role that you want to remove
  # @return [Integer] HTTP Code
  def remove_saml_role(org_id, saml_id)
    make_api_call("/organizations/#{org_id}/samlRoles/#{saml_id}", 'DELETE')
  end
end
