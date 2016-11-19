require 'minitest/autorun'
require './lib/dashboard-api.rb'
require 'minitest/reporters'
require 'vcr'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb

  secrets = YAML::load_file('secrets.yml')

  secrets.each do |k,v|
    config.filter_sensitive_data( k.upcase + "_PLACEHOLDER") { v }
  end
end

class ClientsTest < Minitest::Test
  def setup
    @dashboard_api_key = ENV['dashboard_api_key']
    @org_id = ENV['dashboard_org_id']
    @network_id = ENV['test_network_id']
    @vpn_network = ENV['vpn_network']
    @switch_network = ENV['switch_network']
    @mx_serial = ENV['mx_serial']
    @dapi = DashboardAPI.new(@dashboard_api_key)
  end

  def test_get_client_info_for_device
    VCR.use_cassette('client_info_for_device') do
      res = @dapi.get_client_info_for_device(@mx_serial, 86400)

      assert_kind_of Array, res
      assert_equal 'usage', res[0].keys.first
    end
  end

  def test_timespan_isnt_greater_than_2592000
    assert_raises 'Timespan can not be larger than 2592000 seconds' do
      @dapi.get_client_info_for_device(@mx_serial, 2600000)
    end
  end
end
