require 'minitest/autorun'
require './lib/dashboard-api.rb'
require 'minitest/reporters'
require 'vcr'
require 'json'

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

VCR.configure do |config|
    config.cassette_library_dir = "fixtures/vcr_cassettes"
    config.hook_into :webmock # or :fakeweb
end

class Minitest::Test
  def setup
    @dashboard_api_key = ENV['dashboard_api_key']
    @dapi = DashboardAPI.new(@dashboard_api_key)

    @org_id = ENV['dashboard_org_id']
    @network_id = ENV['test_network_id']
    @vpn_network = ENV['vpn_network']
    @switch_network = ENV['switch_network']
    @mx_serial = ENV['mx_serial']
    @test_admin_id = ENV['test_admin_id']
    @combined_network = ENV['combined_network']
    @spare_mr = ENV['spare_mr']
    @config_template_id = ENV['config_template_id']
    @config_bind_network = ENV['config_bind_network']
    @unclaimed_device = ENV['unclaimed_device']
    @phone_network = ENV['phone_network']
    @contact_id = ENV['phone_contact_id']
    @saml_id = ENV['saml_id']
    @ms_serial = ENV['ms_serial']
    @config_template_id = ENV['config_template_id']

  end
end
