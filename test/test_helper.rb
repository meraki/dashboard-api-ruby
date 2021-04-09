# frozen_string_literal: true

require 'coveralls'
Coveralls.wear!
require 'minitest/autorun'
require './lib/dashboard-api'
require 'minitest/reporters'
require 'vcr'
require 'json'
require 'yaml'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
  config.hook_into :webmock # or :fakeweb

  unless ENV['without-secrets']
    secrets = %w[secret_dashboard_api_key secret_dashboard_org_id secret_ms_serial secret_unclaimed_device
                 secret_combined_network secret_first_name secret_last_name
                 secret_email secret_admin_id secret_shard_id]
    secrets.each do |secret|
      config.filter_sensitive_data(secret) { ENV[secret] }
    end
  end
end

#### DASHBOARD API HELPERS ####
class DashAPITest < Minitest::Test
  def setup
    super
    case name
    when 'test_it_can_post'
      # delete network so we can create it again
      begin
        delete_empty_test_network
      rescue StandardError
      end
    when 'test_it_asserts_when_a_bad_post'
      # ensure the network exists
      delete_empty_test_network
      create_empty_test_network
    when 'test_it_can_put'
      create_empty_test_network('wireless', 'DELETE ME PUT')
      # Wait for Dashboard to catch up
      sleep 3
    when 'test_it_can_delete'
      create_empty_test_network
    end
  end

  def teardown
    case name
    when 'test_it_can_post', 'test_it_asserts_when_a_bad_post', 'test_it_can_put'
      delete_empty_test_network
    end

    super
  end
end

#### SWITCHPORT HELPERS ####
class SwitchportsTest < Minitest::Test
  def teardown
    # reset switchport back to non-updated name
    options = { name: 'Port 2', type: 'access', vlan: '101' }
    @dapi.update_switchport(@ms_serial, 2, options) if name == 'test_it_updates_a_port'
    super
  end
end

#### SSID HELPERS ####
class SSIDsTest < Minitest::Test
  def teardown
    case name
    when 'test_it_can_update_an_ssid'
      # reset the SSID name back to normal
      options = { name: 'API_SSID' }
      res = @dapi.update_single_ssid(@combined_network, 0, options)
    end

    super
  end
end

#### VLAN HELPERS ####
class VLANsTest < Minitest::Test
  def setup
    super

    case name
    when 'test_it_returns_a_vlan', 'test_it_updates_a_vlan', 'test_it_deletes_a_vlan'
      create_vlan
    end
  end

  def create_vlan
    options = { id: 10, name: 'API VLAN', subnet: '192.168.220.0/30',
                applianceIp: '192.168.220.1' }
    @dapi.add_vlan(@combined_network, options)
  rescue StandardError => e
    delete_vlan if e.message.include?(' Vlan has already been taken')
    retry
  end

  def delete_vlan
    @dapi.delete_vlan(@combined_network, 10)
  end

  def teardown
    case name
    when 'test_it_returns_a_vlan', 'test_it_updates_a_vlan'
      delete_vlan
    end

    super
  end
end

#### PHONE HELPERS ####
class PhonesTest < Minitest::Test
  def setup
    super
    create_empty_test_network('phone')
    @phone_network = @test_network_id
    # Wait for Dashboard to catch up
    sleep 3
    @contact_id = @dapi.add_phone_contact(@phone_network, { name: 'API add_contact' })['id']
  end

  def teardown
    delete_empty_test_network
    super
  end
end

#### NETWORK HELPERS ####
class NetworksTest < Minitest::Test
  def setup
    super
    create_empty_test_network
    sleep 2 if name == 'test_delete_a_single_network'
  end

  def teardown
    delete_empty_test_network unless name == 'test_delete_a_single_network'
    super
  end
end

#### DEVICE HELPERS ####
class DevicesTest < Minitest::Test
  def setup
    super
    case name
    when 'test_return_single_device', 'test_update_single_device_attributes'
      # grab a serial number to use here
      @node_serial = @dapi.list_devices_in_network(@combined_network)[0]['serial']
    when 'test_remove_device_from_network'
      # make sure we have a node in the network to remove in the first place
      @node_serial = @dapi.list_devices_in_network(@combined_network)[0]['serial']
      options = { serial: @node_serial }
      begin
        @dapi.claim_device_into_network(@combined_network, options)
      rescue StandardError
        # puts "#{name}: Failed due to #{e}. Are you sure there was a device to claim in the first place?"
      end
    when 'test_claim_device_into_network'
      # remove a node from the network first
      @node_serial = @dapi.list_devices_in_network(@combined_network)[0]['serial']
      begin
        @dapi.remove_device_from_network(@combined_network, @node_serial)
      rescue StandardError
        # puts "#{name}: Failed due to #{e}. Are you sure there was a device to unclaim in the first place?"
      end
    end
  end

  def teardown
    case name
    when 'test_remove_device_from_network'
      options = { serial: @node_serial }
      begin
        @dapi.claim_device_into_network(@combined_network, options)
      rescue StandardError
        # puts "#{name}: Failed due to #{e}. Are you sure there was a device to list in the first place?"
      end

    end
    super
  end
end

#### SAML HELPERS ####
class SAMLTest < Minitest::Test
  def setup
    super
    options = { role: 'api_test_role', orgAccess: 'read-only' }
    @saml_id = @dapi.create_saml_role(@org_id, options)['id']
  end

  def teardown
    @dapi.list_saml_roles(@org_id).each do |role|
      @dapi.remove_saml_role(@org_id, role['id'])
    end
    super
  end
end

#### ADMIN HELPERS ####
class AdminsTest < Minitest::Test
  def setup
    super
    create_admin
    @admin_id = get_admin['id']
  end

  def teardown
    delete_admin
    super
  end

  def create_admin
    # create a random email address to use.
    @dapi.add_admin(@org_id, { email: "delete-me-#{rand(36**10).to_s(36)}@example.com", name: 'delete me',
                               orgAccess: 'read-only' })
  rescue StandardError => e
    delete_admin if e.message.include?('is already registered')
    retry
  end

  def get_admin
    admins = @dapi.list_admins(@org_id)
    admins.each do |entry|
      return entry if entry['email'].include?(:delete)
    end
  end

  def delete_admin
    admins = @dapi.list_admins(@org_id)
    admins.each do |entry|
      @dapi.revoke_admin(@org_id, get_admin['id']) if entry['email'].include?(:delete)
    end
  rescue StandardError => e
    puts " #{name} couldn't delete admin due to #{e}"
  end
end

#### ORGANIZATION HELPERS ####
class OrganizationsTest < Minitest::Test
  def setup
    super
    case name
    when 'test_third_party_vpn_peers', 'test_update_third_party_peers'
      # always have a third party peer to test against
      options = [{ "name": 'API_PEER', "publicIp": '8.8.8.8', "privateSubnets": ['192.168.50.0/24'],
                   "secret": 'password12345' }]
      @dapi.update_third_party_peers(@org_id, options)
    when 'test_it_can_update_an_org'
      # reset the name back to API every time this test is run.
      options = { id: @org_id, name: 'API' }
      @dapi.update_organization(@org_id, options)
    when 'test_current_snmp_status'
      # reset SNMP to false
      options = { v2cEnabled: false }
      @dapi.update_snmp_settings(@org_id, options)
    end
  end
end

#### CONFIG TEMPLATES ####
def get_specific_template(name)
  templates = @dapi.list_templates(@org_id)
  templates.each do |entry|
    return entry if entry['name'].include?(name)
  end
end

#### MINITEST OVERRIDES ####
module Minitest
  class Test
    def setup
      VCR.insert_cassette name
      @dashboard_api_key = ENV['dashboard_api_key']
      @dapi = DashboardAPI.new(@dashboard_api_key)

      @org_id = ENV['org_id']
      @combined_network = ENV['combined_network']

      @ms_serial = ENV['ms_serial']
      @unclaimed_device = ENV['unclaimed_device']
    end

    def teardown
      VCR.eject_cassette name
    end

    def create_empty_test_network(type = 'appliance', name = 'DELETE ME')
      options = { name: name, type: type }
      @test_network_id = @dapi.create_network(@org_id, options)['id']
    rescue StandardError
      # puts "Couldn't create network due to #{e}. Attempting to delete."
      delete_empty_test_network if e.message.include?('Name has already been taken')
      # puts "Network deleteing. Attempting to retry network creation"
      retry
    end

    def delete_empty_test_network
      @test_network_id = get_empty_test_network['id']
      @dapi.delete_network(@test_network_id)
    end

    def get_empty_test_network
      networks = @dapi.get_networks(@org_id)

      networks.each do |entry|
        return entry if entry['name'] == 'DELETE ME'
      end
    end
  end
end
