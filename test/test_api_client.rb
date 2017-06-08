require_relative './test_helper.rb'

class TestAPIClient < Minitest::Test
  def test_it_is_an_API_Client
    assert_kind_of APIClient, APIClient.new('http://test.com', '1234')
  end

  def test_it_can_make_a_get_request
    @api_client = APIClient.new('http://dashboard.meraki.com/api/v0', '12345')
    RestClient.stub(:get, '200') do
      assert_equal '200', @api_client.make_api_call('GET', 'endpoint/url')
    end
  end
end
