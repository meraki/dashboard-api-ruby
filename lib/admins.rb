# Admins section of the Meraki Dashboard API
# @author Joe Letizia
module Admins
  # List all of the administrators for a given org
  # @param [String] org_id organization ID you want the list of administrators for
  # @return [Array] an array of hashes containing each admin and their attributes
  def list_admins(org_id)
    self.make_api_call("/organizations/#{org_id}/admins", 'GET')
  end

  # Add an admin to a specific org
  # @param [String] org_id organization ID you want to add an administrator to
  # @param [Hash] options option hash containing attributes for the new admin. Can contain:
  #   email, name, orgAccess, tags and networks. See the Meraki API Documentation for more details.
  def add_admin(org_id, options)
    options = {:body => options}
    self.make_api_call("/organizations/#{org_id}/admins", 'POST', options)
  end
 
  # Update an administrator for a specific org
  # @param [String] org_id organization ID you want to update an administrator on
  # @param [String] admin_id ID of the admin you want to update
  # @param [Hash] options hash containing the attributes and values you want to update. Can contain:
  #   email, name, orgAccess, tags and networks. See the Meraki API Documentation for more details.
  def update_admin(org_id, admin_id, options)
    options = {:body => options}
    self.make_api_call("/organizations/#{org_id}/admins/#{admin_id}", 'PUT', options)
  end

  # Revoke an administrator for a specific org
  # @param [String] org_id organization ID you want to revoke access on
  # @param [String] admin_id ID of the administrator you want to revoke
  # @return [Integer] HTTP Code
  def revoke_admin(org_id, admin_id)
    self.make_api_call("/organizations/#{org_id}/admins/#{admin_id}", 'DELETE')
  end
end
