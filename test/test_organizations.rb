require './test/test_helper'

class OrganizationsTest < Minitest::Test
  def test_get_an_organization
    res = @dapi.get_organization(@org_id)
    assert_equal @org_id.to_i, res['id']
  end

  def test_it_returns_as_json
    res = @dapi.get_organization(@org_id)
    assert_kind_of Hash, res
  end

  def test_get_license_state_for_an_org
    res = @dapi.get_license_state(@org_id)
    # oops :p
    assert_equal 'License Required', res['status']
  end

  def test_license_state_returns_as_hash
    res = @dapi.get_license_state(@org_id)
    assert_kind_of Hash, res
  end

  def test_get_inventory_for_an_org
    res = @dapi.get_inventory(@org_id)
    assert_kind_of Array, res
  end

  def test_inventory_returns_as_array
    res = @dapi.get_inventory(@org_id)
    assert_kind_of Array, res
  end

  def test_current_snmp_status
    res = @dapi.get_snmp_settings(@org_id)
    assert_equal false, res['v2cEnabled']
  end

  def test_update_snmp_settings
    options = { v2cEnabled: true }

    res = @dapi.update_snmp_settings(@org_id, options)
    assert_equal true, res['v2cEnabled']
  end

  def test_snmp_returns_as_hash
    res = @dapi.get_snmp_settings(@org_id)
    assert_kind_of Hash, res
  end

  def test_third_party_vpn_peers
    res = @dapi.get_third_party_peers(@org_id)
    assert_equal 'API_PEER', res[0]['name']
  end

  def test_third_party_peer_returns_as_array
    res = @dapi.get_third_party_peers(@org_id)
    assert_kind_of Array, res
  end

  def test_update_third_party_peers
    options = [{ "name": 'API_PEER_UPDATED', "publicIp": '8.8.8.8', "privateSubnets": ['192.168.50.0/24'],
                 "secret": 'password12345' }]
    res = @dapi.update_third_party_peers(@org_id, options)

    assert_equal 'API_PEER_UPDATED', res[0]['name']
    assert_kind_of Array, res
  end

  def test_it_lists_all_orgs_a_user_is_on
    res = @dapi.list_all_organizations
    assert_kind_of Array, res
  end

  def test_it_can_update_an_org
    options = { id: @org_id, name: 'API_UPDATED' }
    res = @dapi.update_organization(@org_id, options)

    assert_kind_of Hash, res
    assert_equal options[:name], res['name']
  end

  def test_it_can_create_an_org
    options = { name: 'DELETE ME ORG' }
    res = @dapi.create_organization(options)

    assert_kind_of Hash, res
    assert_equal options[:name], res['name']
  end

  def test_it_can_clone_an_org
    options = { name: 'API CLONED ORG' }
    res = @dapi.clone_organization(@org_id, options)

    assert_kind_of Hash, res
    assert_equal options[:name], res['name']
  end

  def test_it_can_claim_a_thing
    options = { serial: @unclaimed_device }
    res = @dapi.claim(@org_id, options)

    assert_equal 200, res
  end
end
