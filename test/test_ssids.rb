require './test/test_helper'

class SSIDsTest < Minitest::Test
  def test_it_lists_the_ssids
    res = @dapi.list_ssids_in_network(@combined_network)

    assert_kind_of Array, res
    assert_equal true, res[0].keys.include?('number')
  end

  def test_it_returns_a_single_ssid
      res = @dapi.get_single_ssid(@combined_network, 0)

      assert_kind_of Hash, res
      assert_equal true, res.keys.include?('number')
  end

  def test_it_requires_integer_for_single_ssid
    assert_raises 'Please provide a valid SSID number' do
      res = @dapi.get_single_ssid(@combined_network, 'abc')
    end
  end

  def test_it_can_update_an_ssid
    options = {:name => 'API_SSID_UPDATED'}
    res = @dapi.update_single_ssid(@combined_network, 0, options)

    assert_kind_of Hash, res
    assert_equal options[:name], res['name']
  end
end
