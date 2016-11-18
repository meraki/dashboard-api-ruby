require 'minitest/autorun'
require './lib/dashboard-api.rb'
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
    @unclaimed_device = ENV['unclaimed_device']
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
      res = @dapi.get_snmp_settings(@org_id)
      assert_equal true, res['v2cEnabled']
    end
  end

  def test_update_snmp_settings
   VCR.use_cassette("update_snmp_status") do
      options = {:v2cEnabled => false}

      res = @dapi.update_snmp_settings(@org_id, options)
      assert_equal false, res['v2cEnabled']
    end
  end

  def test_snmp_returns_as_hash
   VCR.use_cassette("get_snmp_status") do
      res = @dapi.get_snmp_settings(@org_id)
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
    VCR.use_cassette('get_third_party_vpn_peers') do
      res = @dapi.get_third_party_peers(@org_id)
      assert_kind_of Array, res
    end
  end

  def test_update_third_party_peers
    VCR.use_cassette("update_third_party_vpn_peers") do
      options = [{:name => 'api', :publicIp => '8.8.4.4', :privateSubnets => '["192.168.151.0/30"]', :secret => 'API123456'}]
      options = [{"name":"Your peer","publicIp":"192.168.0.1","privateSubnets":["172.168.0.0/16","172.169.0.0/16"],"secret":"asdf1234"}]
      res = @dapi.update_third_party_peers(@org_id, options)
    end
  end
  
  def test_it_lists_all_orgs_a_user_is_on
    VCR.use_cassette('list_all_orgs_for_user') do
      res = @dapi.list_all_organizations

      assert_kind_of Array, res
    end
  end

  def test_it_can_update_an_org
    VCR.use_cassette('update_a_single_org') do
      options = {:id => @org_id, :name => 'Rerek Divard'}
      res = @dapi.update_organization(@org_id, options)

      assert_kind_of Hash, res
      assert_equal options[:name], res['name']
    end
  end

  def test_it_can_create_an_org
    VCR.use_cassette('create_a_new_org') do
      options = {:name => 'API test org'}
      res = @dapi.create_organization(options)

      assert_kind_of Hash, res
      assert_equal options[:name], res['name']
    end
  end

  def test_it_can_clone_an_org
    VCR.use_cassette('clone_a_single_org') do
      options = {:name => 'API cloned org'}
      res = @dapi.clone_organization(@org_id, options)

      assert_kind_of Hash, res
      assert_equal options[:name], res['name']
    end
  end

  def test_it_can_claim_a_thing
    VCR.use_cassette('claim_a_thing') do
      options = {:serial => @unclaimed_device}
      res = @dapi.claim(@org_id, options)

      assert_equal 200, res
    end
  end
end
