require 'minitest/autorun'
require './lib/dashboard_api.rb'
require 'minitest/reporters'
require 'vcr'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

VCR.configure do |config|
    config.cassette_library_dir = "fixtures/vcr_cassettes"
    config.hook_into :webmock # or :fakeweb
end

class OrganizationsTest < Minitest::Test
  def setup
    @dashboard_api_key = ENV['dashboard_api_key']
    @org_id = ENV['dashboard_org_id']
    @network_id = ENV['test_network_id']
    @dapi = DashboardAPI.new(@dashboard_api_key)
  end

  def test_get_an_organization
    VCR.use_cassette("get_an_org") do
      res = @dapi.get_organization(@org_id)
      assert_equal @org_id.to_i, res['id']
    end
  end

  def test_it_returns_as_json
    VCR.use_cassette("get_an_org") do
      res = @dapi.get_organization(@org_id)
      assert_kind_of Hash, res
    end
  end

  def test_get_license_state_for_an_org
    VCR.use_cassette("get_license_state") do
      res = @dapi.get_license_state(@org_id)
      assert_equal 'OK', res['status']
    end
  end

  def test_license_state_returns_as_hash
    VCR.use_cassette("get_license_state") do
      res = @dapi.get_license_state(@org_id)
      assert_kind_of Hash, res
    end
  end

  def test_get_inventory_for_an_org
    VCR.use_cassette("get_inventory") do
      res = @dapi.get_inventory(@org_id)

      assert_kind_of Array, res
    end
  end

  def test_inventory_returns_as_array
    VCR.use_cassette("get_inventory") do
      res = @dapi.get_inventory(@org_id)
      assert_kind_of Array, res
    end
  end

  def test_current_snmp_status
   VCR.use_cassette("get_snmp_status") do
      res = @dapi.get_snmp_status(@org_id)
      assert_equal true, res['v2cEnabled']
    end
  end

  def test_snmp_returns_as_array
   VCR.use_cassette("get_snmp_status") do
      res = @dapi.get_snmp_status(@org_id)
      assert_kind_of Hash,res
    end
  end

  def test_third_party_vpn_peers
    VCR.use_cassette("get_third_party_vpn_peers") do
      res = @dapi.get_third_party_peers(@org_id)
      assert_equal 'test', res[0]['name']
    end
  end

  def test_third_party_peer_returns_as_array
    VCR.use_cassette("get_third_party_vpn_peers") do
      res = @dapi.get_third_party_peers(@org_id)
      assert_kind_of Array, res
    end
  end
end
