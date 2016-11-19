require './test/test_helper'

class SSIDsTest < Minitest::Test
  def test_it_lists_the_ssids
    VCR.use_cassette('list_ssids_in_network') do
      res = @dapi.list_ssids_in_network(@combined_network)

      assert_kind_of Array, res
      assert_equal true, res[0].keys.include?('number')
    end
  end

  def test_it_returns_a_single_ssid
    VCR.use_cassette('returns_single_ssid') do
      res = @dapi.get_single_ssid(@combined_network, 0)

      assert_kind_of Hash, res
      assert_equal true, res.keys.include?('number')
    end
  end

  def test_it_requires_integer_for_single_ssid
    VCR.use_cassette('requires_integer_ssid_number') do
      assert_raises 'Please provide a valid SSID number' do
        res = @dapi.get_single_ssid(@combined_network, 'abc')
      end
    end
  end

  def test_it_can_update_an_ssid
    VCR.use_cassette('update_a_single_ssid') do
      options = {:name => 'api_test_ssid'}
      res = @dapi.update_single_ssid(@combined_network, 14, options)

      assert_kind_of Hash, res
      assert_equal 'api_test_ssid', res['name']
    end
  end
end
