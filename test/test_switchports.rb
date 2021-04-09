# frozen_string_literal: true

require './test/test_helper'

class SwitchportsTest < Minitest::Test
  def test_list_switch_ports
    res = @dapi.get_switch_ports(@ms_serial)

    assert_kind_of Array, res
    assert_equal true, res[0].keys.include?('name')
  end

  def test_return_a_single_port
    res = @dapi.get_single_switch_port(@ms_serial, 1)

    assert_kind_of Hash, res
    assert_equal true, res.keys.include?('name')
  end

  def test_port_number_is_integer
    assert_raises 'Invalid switchport provided' do
      @dapi.get_single_switch_port(@ms_serial, 'abc')
    end
  end

  def test_it_updates_a_port
    options = { name: 'API_PORT_UPDATED', type: 'access', vlan: '101' }

    res = @dapi.update_switchport(@ms_serial, 2, options)

    assert_kind_of Hash, res
    assert_equal options[:name], res['name']
  end
end
