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

class AdminsTest < Minitest::Test
  def setup
    @dashboard_api_key = ENV['dashboard_api_key']
    @org_id = ENV['dashboard_org_id']
    @network_id = ENV['test_network_id']
    @vpn_network = ENV['vpn_network']
    @switch_network = ENV['switch_network']
    @mx_serial = ENV['mx_serial']
    @test_admin_id = ENV['test_admin_id']
    @dapi = DashboardAPI.new(@dashboard_api_key)
  end

  def test_it_lists_the_dashboard_admins
    VCR.use_cassette('list_admins') do
      res = @dapi.list_admins(@org_id)

      assert_kind_of Array, res
    end
  end

  def test_it_can_create_admins
    VCR.use_cassette('add_admin') do
      options = {:email => 'api-admin@example.com', :name => 'example admin',
                 :orgAccess => 'none'}
      res = @dapi.add_admin(@org_id, options)

      assert_kind_of Hash, res
    end
  end

  def test_it_can_update_an_admin
    VCR.use_cassette('update_admin') do
      options = {:name => 'updated admin'}
      res = @dapi.update_admin(@org_id, @test_admin_id, options)

      assert_kind_of Hash, res
      assert_equal options[:name], res['name']
    end
  end

  def test_it_can_revoke_an_admin
    VCR.use_cassette('revoke_admin') do
      res = @dapi.revoke_admin(@org_id, @test_admin_id)

      assert_equal 204, res.code
    end
  end

end
