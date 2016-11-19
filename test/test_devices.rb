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

class DevicesTest < Minitest::Test
  def setup
    @dashboard_api_key = ENV['dashboard_api_key']
    @org_id = ENV['dashboard_org_id']
    @network_id = ENV['test_network_id']
    @vpn_network = ENV['vpn_network']
    @switch_network = ENV['switch_network']
    @mx_serial = ENV['mx_serial']
    @combined_network = ENV['combined_network']
    @spare_mr = ENV['spare_mr']
    @dapi = DashboardAPI.new(@dashboard_api_key)
  end

  def test_list_devices_in_network
    VCR.use_cassette('list_devices_in_network') do
      res = @dapi.list_devices_in_network(@switch_network)

      assert_kind_of Array, res
      assert_equal true, res[0].keys.include?('name')
    end
  end

  def test_return_single_device
    VCR.use_cassette('return_a_single_device') do
      res = @dapi.get_single_device(@combined_network, @mx_serial)

      assert_kind_of Hash, res
      assert_equal true, res.keys.include?('name')
    end
  end

  def test_return_device_uplink_stats
    VCR.use_cassette('return_device_uplink_stats') do
      res = @dapi.get_device_uplink_stats(@combined_network, @mx_serial)
      assert_kind_of Array, res
      assert_equal true, res[0].keys.include?('interface')
    end
  end

  def test_update_single_device_attributes
    VCR.use_cassette('update_device_attributes') do
      options = {:name => 'test_name'}
      res = @dapi.update_device_attributes(@combined_network, @mx_serial, options)

      assert_kind_of Hash, res
      assert_equal true, res.keys.include?('name')
    end
  end

  def test_claim_device_into_network
    VCR.use_cassette('claim_device_to_network') do
      options = {:serial => @spare_mr}

      res = @dapi.claim_device_into_network(@combined_network, options)

      assert_equal 200, res
    end
  end

  def test_remove_device_from_network
    VCR.use_cassette('remove_device_from_network') do
      res = @dapi.remove_device_from_network(@combined_network, @spare_mr)

      assert_equal 204, res
    end
  end

end
