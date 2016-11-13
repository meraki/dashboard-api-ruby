require 'minitest/autorun'
require './lib/dashboard_api.rb'
require 'minitest/reporters'
require 'vcr'
require 'json'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

VCR.configure do |config|
    config.cassette_library_dir = "fixtures/vcr_cassettes"
    config.hook_into :webmock # or :fakeweb
end

class DashAPITest < Minitest::Test
  def setup
    @dashboard_api_key = ENV['dashboard_api_key']
    @org_id = ENV['dashboard_org_id']

    @dapi = DashboardAPI.new(@dashboard_api_key)
  end

  def test_it_is_a_dash_api
    assert_kind_of DashboardAPI, @dapi
  end

  def test_api_key_is_a_string
    assert_kind_of String, @dapi.key
  end

  def test_it_can_get
    VCR.use_cassette('it_can_get') do
      endpoint_url = "/organizations/#{@org_id}"
      http_method = 'GET'
      res = @dapi.make_api_call(endpoint_url, http_method)

      assert_equal @org_id.to_i, res['id']
    end 
  end

  def test_it_can_post
    VCR.use_cassette('it_can_post') do
      endpoint_url = "/organizations/#{@org_id}/networks"
      http_method = 'POST'
      options_hash = {:headers => {"Content-Type" => 'application/json'}, :body =>{:name => 'test_network2', :type => 'wireless'}}

      res = @dapi.make_api_call(endpoint_url, http_method, options_hash)

      assert_equal 'Created', res.response.message
    end
  end

  def test_it_asserts_when_a_bad_post
    VCR.use_cassette('network_already_exists_post') do
      assert_raises 'RuntimeError: Bad Request due to the following error(s): ["Validation failed: Name has already been taken"]' do
        endpoint_url = "/organizations/#{@org_id}/networks"
        http_method = 'POST'
        options_hash = {:headers => {"Content-Type" => 'application/json'}, :body =>{:name => 'test_network2', :type => 'wireless'}}

        res = @dapi.make_api_call(endpoint_url, http_method, options_hash)
      end
    end
  end
end
