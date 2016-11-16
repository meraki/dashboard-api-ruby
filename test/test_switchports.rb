require 'minitest/autorun'
require './lib/dashboard-api.rb'
require 'minitest/reporters'
require 'vcr'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

VCR.configure do |config|
    config.cassette_library_dir = "fixtures/vcr_cassettes"
    config.hook_into :webmock # or :fakeweb
end

class SwitchportsTest < Minitest::Test
  def setup
    @dashboard_api_key = ENV['dashboard_api_key']
    @org_id = ENV['dashboard_org_id']
    @network_id = ENV['test_network_id']
    @vpn_network = ENV['vpn_network']
    @switch_network = ENV['switch_network']
    @mx_serial = ENV['mx_serial']
    @ms_serial = ENV['ms_serial']
    @dapi = DashboardAPI.new(@dashboard_api_key)
  end
  
  def test_list_switch_ports
    VCR.use_cassette('list_switchports_for_switch') do
      res = @dapi.get_switch_ports(@ms_serial)

      assert_kind_of Array, res
      assert_equal true, res[0].keys.include?('name')
    end
  end

  def test_return_a_single_port
    VCR.use_cassette('return_single_port') do
      res = @dapi.get_single_switch_port(@ms_serial, 1)

      assert_kind_of Hash, res
      assert_equal true, res.keys.include?('name')
    end
  end

  def test_port_number_is_integer
    assert_raises 'Invalid switchport provided' do
      @dapi.get_single_switch_port(@ms_serial, 'abc')
    end
  end

  def test_it_updates_a_port
    VCR.use_cassette('update_single_switchport') do
      options = {:name => 'api_port', :type => 'access', :vlan => '101'}

      res = @dapi.update_switchport(@ms_serial, 7, options)

      assert_kind_of Hash, res
      assert_equal 'api_port', res['name']
    end
  end

end
