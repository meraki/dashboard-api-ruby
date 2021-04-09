# frozen_string_literal: true

require './test/test_helper'

class DevicesTest < Minitest::Test
  def test_list_devices_in_network
    res = @dapi.list_devices_in_network(@combined_network)

    assert_kind_of Array, res
    assert_equal true, res[0].keys.include?('name')
  end

  def test_return_single_device
    res = @dapi.get_single_device(@combined_network, @node_serial)

    assert_kind_of Hash, res
    assert_equal true, res.keys.include?('name')
    assert_equal @node_serial, res['serial']
  end

  # def test_return_device_uplink_stats
  #   res = @dapi.get_device_uplink_stats(@combined_network, @node_serial)
  #   assert_kind_of Array, res
  #   assert_equal true, res[0].keys.include?('interface')
  # end

  def test_update_single_device_attributes
    options = { name: 'API_TEST_NAME' }
    res = @dapi.update_device_attributes(@combined_network, @node_serial, options)

    assert_kind_of Hash, res
    assert_equal true, res.keys.include?('name')
  end

  def test_claim_device_into_network
    options = { serial: @node_serial }
    res = @dapi.claim_device_into_network(@combined_network, options)

    assert_equal 200, res
  end

  def test_remove_device_from_network
    res = @dapi.remove_device_from_network(@combined_network, @node_serial)

    assert_equal 204, res
  end
end
