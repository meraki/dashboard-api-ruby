# Phones section of the Meraki Dashboard API
# @author Joe Letizia
module Phones
  # Get list of phone contacts
  # @param [String] network_id the network id you want to list contacts for
  # @return [Array] an array of hashes containing attribute information for each contact
  def list_phone_contacts(network_id)
    make_api_call("/networks/#{network_id}/phoneContacts", 'GET')
  end

  # Add a single phone contact
  # @param [String] network_id the network id you want to add the contact to
  # @param [Hash] options an options hash that contains the contact attributes. Currently only supports the name attribute.
  # @return [Hash] returns the hash containing the contact attributes
  def add_phone_contact(network_id, options)
    raise 'Options were not passed as a Hash' unless options.is_a?(Hash)

    make_api_call("/networks/#{network_id}/phoneContacts", 'POST', options)
  end

  # Update a single phone contact
  # @param [String] network_id the network id you want to update the contact in
  # @param [String] contact_id the ID of the contact you want to update
  # @param [Hash] options an options hash that contains the contact attributes. Currently only supports the name attribute.
  # @return [Hash] returns the hash containing the contacts updated attributes
  def update_phone_contact(network_id, contact_id, options)
    raise 'Options were not passed as a Hash' unless options.is_a?(Hash)

    make_api_call("/networks/#{network_id}/phoneContacts/#{contact_id}", 'PUT', options)
  end

  # Delete a single phone contact
  # @param [String] network_id the network id you want to delete the contact on
  # @param [String] contact_id the ID of the contact you want to delete
  # @return [Integer] HTTP Code
  def delete_phone_contact(network_id, contact_id)
    make_api_call("/networks/#{network_id}/phoneContacts/#{contact_id}", 'DELETE')
  end
end
