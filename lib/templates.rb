# Templates section of the Meraki Dashboard API
# @author Joe Letizia
module Templates
  # Return a list of all templates for a specific organization
  # @param [String] org_id organization ID where that we want to list all of the templates from
  # @return [Array] an array of hashes containing the attributes for all configuration templates
  def list_templates(org_id)
    self.make_api_call("/organizations/#{org_id}/configTemplates", 'GET')
  end
  
  # Remove a single configuration template
  # @param [String] org_id organization ID where that we want to remove the templates from
  # @param [String] template_id the template ID we want to delete
  # @return [Integer] HTTP code
  def remove_template(org_id, template_id)
    self.make_api_call("/organizations/#{org_id}/configTemplates/#{template_id}", 'DELETE')
  end
end
