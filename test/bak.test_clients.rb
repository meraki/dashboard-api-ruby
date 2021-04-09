# frozen_string_literal: true

require './test/test_helper'

class ClientsTest < Minitest::Test
  def test_get_client_info_for_device
    VCR.use_cassette('client_info_for_device') do
      res = @dapi.get_client_info_for_device(@mx_serial, 86_400)

      assert_kind_of Array, res
      assert_equal 'usage', res[0].keys.first
    end
  end

  def test_timespan_isnt_greater_than_720_hours
    assert_raises 'Timespan can not be larger than 2592000 seconds' do
      @dapi.get_client_info_for_device(@mx_serial, 2_600_000)
    end
  end
end
