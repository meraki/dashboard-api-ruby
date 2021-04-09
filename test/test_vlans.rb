# frozen_string_literal: true

require './test/test_helper'

class VLANsTest < Minitest::Test
  def test_it_lists_the_vlans
    res = @dapi.list_vlans(@combined_network)
    assert_kind_of Array, res
  end

  def test_it_returns_a_vlan
    res = @dapi.return_vlan(@combined_network, 10)

    assert_kind_of Hash, res
    assert_equal 10, res['id']
  end

  def test_it_adds_a_vlan
    begin
      options = { id: 10, name: 'API VLAN', subnet: '192.168.220.0/30',
                  applianceIp: '192.168.220.1' }
      res = @dapi.add_vlan(@combined_network, options)
    rescue StandardError => e
      delete_vlan if e.message.include?(' Vlan has already been taken')
      retry
    end

    assert_kind_of Hash, res
    assert_equal options[:id], res['id']
  end

  def test_options_is_hash_add_vlan
    assert_raises 'Options were not passed as a hash' do
      @dapi.add_a_vlan(@combined_network, 'abc')
    end
  end

  def test_it_updates_a_vlan
    options = { name: 'API VLAN UPDATED' }
    res = @dapi.update_vlan(@combined_network, 10, options)

    assert_kind_of Hash, res
    assert_equal options[:name], res['name']
  end

  def test_options_is_hash_add_vlan
    assert_raises 'Options were not passed as a hash' do
      @dapi.update_a_vlan(@combined_network, 10, 'abc')
    end
  end

  def test_it_deletes_a_vlan
    res = @dapi.delete_vlan(@combined_network, 10)
    assert_equal 204, res.code
  end
end
