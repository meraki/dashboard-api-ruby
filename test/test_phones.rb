require 'minitest/autorun'
require './lib/dashboard-api.rb'
require 'minitest/reporters'
require 'vcr'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

VCR.configure do |config|
    config.cassette_library_dir = "fixtures/vcr_cassettes"
    config.hook_into :webmock # or :fakeweb
end

class PhonesTest < Minitest::Test
  def setup
    @dashboard_api_key = ENV['dashboard_api_key']
    @org_id = ENV['dashboard_org_id']
    @network_id = ENV['test_network_id']
    @vpn_network = ENV['vpn_network']
    @switch_network = ENV['switch_network']
    @mx_serial = ENV['mx_serial']
    @phone_network = ENV['phone_network']
    @contact_id = ENV['phone_contact_id']
    @dapi = DashboardAPI.new(@dashboard_api_key)
  end

  def test_it_can_list_contacts
    VCR.use_cassette('list_phone_contacts') do
      res = @dapi.list_phone_contacts(@phone_network)
      
      assert_kind_of Array, res
    end
  end
  
  def test_it_can_add_a_contact
    VCR.use_cassette('add_a_phone_contact') do
      options = {:name => 'api test'}
      res = @dapi.add_phone_contact(@phone_network, options)
      
      assert_kind_of Hash, res
      assert_equal options[:name], res['name']
    end
  end

  def test_it_can_update_a_contact
    VCR.use_cassette('update_a_phone_contact') do
      options = {:name => 'updated test'}
      res = @dapi.update_phone_contact(@phone_network, @contact_id, options)
      
      assert_kind_of Hash, res
      assert_equal options[:name], res['name']
    end
  end

  def test_it_can_delete_a_contact
    VCR.use_cassette('delete_a_phone_contact') do
      res = @dapi.delete_phone_contact(@phone_network, @contact_id)
      
      assert_equal 204, res.code    
    end
  end

end
