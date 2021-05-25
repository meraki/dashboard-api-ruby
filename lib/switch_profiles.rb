# frozen_string_literal: true

# Switch Profiles section of the Meraki Dashboard API
# @author Shane Short
module SwitchProfiles
  # Get the switch profiles for a given org/config template
  # @param [String] org_id Organization ID
  # @param [String] template_id Configuration Template ID Containing the profiles
  # @return [Array] an array of Hashes, containing the switch profile IDs and the applicable model/name
  def get_organization_config_template_switch_profiles(org_id, template_id)
    make_api_call("/organizations/#{org_id}/configTemplates/#{template_id}/switchProfiles", :get)
  end
end
