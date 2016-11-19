require './test/test_helper'

class DashAPITest < Minitest::Test
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

      assert_equal @org_id, res['organizationId']
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

  def test_it_asserts_with_bad_http_method
    assert_raises 'Invalid HTTP Method. Only GET, POST, PUT and DELETE are supported.' do
      @dapi.make_api_call('bogus', 'CATCHME')
    end
  end

  def test_it_can_put
    VCR.use_cassette('it_can_put') do
      endpoint_url = "/networks/#{@network_id}"
      http_method = 'PUT'

      options_hash = {:headers => {"Content-Type" => 'application/json'}, :body => {:id => "#{@network_id}", :name => 'test_network_renamed'}}
      res = @dapi.make_api_call(endpoint_url, http_method, options_hash)

      assert_equal @org_id, res['organizationId']
    end
  end

  def test_it_asserts_when_bad_network_id_on_put
    assert_raises '404 returned. Are you sure you are using the proper IDs?' do
      VCR.use_cassette('bad_network_id_put') do
        endpoint_url = "/networks/11111"
        http_method = 'PUT'

        options_hash = {:headers => {"Content-Type" => 'application/json'}, :body => {:name => 'test_network_renamed2'}}
        res = @dapi.make_api_call(endpoint_url, http_method, options_hash)
      end
    end
  end

  def test_it_can_delete
    VCR.use_cassette('delete_single_network') do
      endpoint_url = "/networks/#{@network_id}"
      http_method = 'DELETE'

      res = @dapi.make_api_call(endpoint_url, http_method)
    end
  end

end
