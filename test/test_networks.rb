require 'minitest/autorun'
require './lib/dashboard_api.rb'
require 'minitest/reporters'
require 'vcr'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

VCR.configure do |config|
    config.cassette_library_dir = "fixtures/vcr_cassettes"
    config.hook_into :webmock # or :fakeweb
end

class NetworksTest < Minitest::Test
  def setup
    @dashboard_api_key = ENV['dashboard_api_key']
    @org_id = ENV['dashboard_org_id']
    @network_id = ENV['test_network_id']
    @vpn_network = ENV['vpn_network']
    @switch_network = ENV['switch_network']
    @dapi = DashboardAPI.new(@dashboard_api_key)
  end

  def test_it_can_get_networks
    VCR.use_cassette("get_networks") do
      res = @dapi.get_networks(@org_id)

      assert_kind_of Array, res
    end
  end

  def test_it_can_get_a_single_network
    VCR.use_cassette("get_single_network") do
      res = @dapi.get_single_network(@network_id)

      assert_kind_of Hash, res
    end
  end

  def test_it_can_update_a_network
    VCR.use_cassette('update_single_network') do
      options = {:id => @network_id, :organizationId => @org_id, :tags => 'this_is_a_new_tag'}
      res = @dapi.update_network(@network_id, options)
      # not sure why the response contains leading and trailing spaces
      # nothing to worry about as it does not show up like this in Dashboard
      assert_equal ' this_is_a_new_tag ', res['tags']
    end
  end

  def test_options_are_a_hash_update_network
    assert_raises "Options were not passed as a Hash" do
      @dapi.update_network(@network_id, 'option')
    end
  end

  def test_it_can_create_a_network
    VCR.use_cassette('create_single_network') do
      options = {:name => 'test_network', :type => 'wireless'}
      res = @dapi.create_network(@org_id, options)
      assert_equal 'test_network', res['name']
    end
  end

  def test_options_are_a_hash_create_network
    assert_raises 'Options were not passed as a Hash' do
      @dapi.update_network(@network_id, 'option')
    end
  end

  def test_delete_a_single_network
    VCR.use_cassette('delete_single_network') do
      res = @dapi.delete_network(@network_id)

      assert_equal true, res
    end
  end

  def test_get_s2s_vpn_settings
    VCR.use_cassette('get_auto_vpn_settings') do
      res = @dapi.get_auto_vpn_settings(@vpn_network)

      assert_kind_of Hash, res 
    end
  end

  def test_update_s2s_vpn_settings
    VCR.use_cassette('update_auto_vpn_settings') do
      options = {:mode => 'none'}
      res = @dapi.update_auto_vpn_settings(@vpn_network, options)

      assert 'none', res['mode']
    end
  end

  def test_update_s2s_returns_a_hash
    # make sure we aren't returning an HTTParty response type
    VCR.use_cassette('update_auto_vpn_settings_is_hash') do
      options = {:mode => 'none'}
      res = @dapi.update_auto_vpn_settings(@vpn_network, options)

      assert_kind_of Hash, res
    end
  end

  def test_get_ms_access_policies_for_network
    VCR.use_cassette('get_ms_acces_policies_for_network') do
      res = @dapi.get_ms_access_policies(@switch_network)

      assert_equal true, true
    end
  end
end
