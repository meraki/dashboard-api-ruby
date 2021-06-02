# frozen_string_literal: true

# Templates section of the Meraki Dashboard API
# @author Joe Letizia
module Templates
  # Return a list of all templates for a specific organization
  # @param [String] org_id organization ID where that we want to list all of the templates from
  # @return [Array] an array of hashes containing the attributes for all configuration templates
  def list_templates(org_id)
    make_api_call("/organizations/#{org_id}/configTemplates", :get)
  end

  # Return a specific template for a specific organization
  # @param [String] org_id organization ID that the template belongs to
  # @param [String] template_id the ID of the template you wish to fetch
  # @return [Hash] the template object in hash form
  def get_organization_config_template(org_id, template_id)
    make_v1_api_call("/organizations/#{org_id}/configTemplates/#{template_id}", :get)
  end

  # Remove a single configuration template
  # @param [String] org_id organization ID where that we want to remove the templates from
  # @param [String] template_id the template ID we want to delete
  # @return [Integer] HTTP code
  def remove_template(org_id, template_id)
    make_api_call("/organizations/#{org_id}/configTemplates/#{template_id}", :delete)
  end
end
