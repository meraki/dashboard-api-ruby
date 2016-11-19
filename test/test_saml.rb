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

class SAMLTest < Minitest::Test
  def setup
    @dashboard_api_key = ENV['dashboard_api_key']
    @org_id = ENV['dashboard_org_id']
    @network_id = ENV['test_network_id']
    @vpn_network = ENV['vpn_network']
    @switch_network = ENV['switch_network']
    @mx_serial = ENV['mx_serial']
    @saml_id = ENV['saml_id']
    @dapi = DashboardAPI.new(@dashboard_api_key)
  end

  def test_it_can_list_saml_roles
    VCR.use_cassette('list_saml_roles') do
      res = @dapi.list_saml_roles(@org_id)

      assert_kind_of Array, res
    end
  end

  def test_it_can_return_a_single_saml_role
    VCR.use_cassette('return_a_saml_role') do
      res = @dapi.return_saml_role(@org_id, @saml_id)

      assert_kind_of Hash, res
      assert_equal @saml_id, res['id']
    end
  end

  def test_it_can_create_saml_roles
    VCR.use_cassette('create_saml_role') do
      options = {:role => 'api_test_role', :orgAccess => 'full'}
      res = @dapi.create_saml_role(@org_id, options)

      assert_kind_of Hash, res
      assert_equal options[:role], res['role']
    end
  end

  def test_it_can_update_saml_roles
    VCR.use_cassette('update_saml_role') do
      options = {:role => 'api_test_role_updated', :orgAccess => 'full'}
      res = @dapi.update_saml_role(@org_id, @saml_id, options)

      assert_kind_of Hash, res
      assert_equal options[:role], res['role']
    end
  end

  def test_it_can_remove_saml_role
    VCR.use_cassette('remove_a_saml_role') do
      res = @dapi.remove_saml_role(@org_id, @saml_id)

      assert_equal 204, res.code
    end
  end
end
