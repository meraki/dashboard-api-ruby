require 'minitest/autorun'
require './lib/dashboard-api.rb'
require 'minitest/reporters'
require 'vcr'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

VCR.configure do |config|
    config.cassette_library_dir = "fixtures/vcr_cassettes"
    config.hook_into :webmock # or :fakeweb
end

class TemplatesTest < Minitest::Test
  def setup
    @dashboard_api_key = ENV['dashboard_api_key']
    @org_id = ENV['dashboard_org_id']
    @network_id = ENV['test_network_id']
    @vpn_network = ENV['vpn_network']
    @switch_network = ENV['switch_network']
    @mx_serial = ENV['mx_serial']
    @config_template_id = ENV['config_template_id']
    @dapi = DashboardAPI.new(@dashboard_api_key)
  end

  def test_it_can_list_an_orgs_templates
    VCR.use_cassette('list_all_templates') do
      res = @dapi.list_templates(@org_id)
      
      assert_kind_of Array, res
    end
  end

  def test_it_can_remove_a_template
    VCR.use_cassette('remove_a_template') do
      res = @dapi.remove_template(@org_id, @config_template_id)
      
      assert_equal 204, res.code
    end
  end
end
