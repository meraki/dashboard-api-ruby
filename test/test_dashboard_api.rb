require './test/test_helper'

class DashAPITest < Minitest::Test
  def test_it_is_a_dash_api
    assert_kind_of DashboardAPI, @dapi
  end

  def test_api_key_is_a_string
    assert_kind_of String, @dapi.key
  end

  def test_it_can_get
    endpoint_url = "/organizations/#{@org_id}"
    http_method = 'GET'
    res = @dapi.make_api_call(endpoint_url, http_method)

    assert_equal @org_id.to_i, res['id']
  end

  def test_it_can_post
    endpoint_url = "/organizations/#{@org_id}/networks"
    http_method = 'POST'
    options_hash = {:headers => {"Content-Type" => 'application/json'}, :body =>{:name => 'DELETE ME', :type => 'wireless'}}

    res = @dapi.make_api_call(endpoint_url, http_method, options_hash)

    assert_equal @org_id, res['organizationId']
  end

  def test_it_asserts_when_a_bad_post
    assert_raises 'RuntimeError: Bad Request due to the following error(s): ["Validation failed: Name has already been taken"]' do
      endpoint_url = "/organizations/#{@org_id}/networks"
      http_method = 'POST'
      options_hash = {:headers => {"Content-Type" => 'application/json'}, :body =>{:name => 'DELETE ME', :type => 'appliance'}}

      res = @dapi.make_api_call(endpoint_url, http_method, options_hash)
    end
  end

  def test_it_asserts_with_bad_http_method
    assert_raises 'Invalid HTTP Method. Only GET, POST, PUT and DELETE are supported.' do
      @dapi.make_api_call('bogus', 'CATCHME')
    end
  end

  def test_it_can_put
    endpoint_url = "/networks/#{@test_network_id}"
    http_method = 'PUT'

    options_hash = {:body => {:id => "#{@test_network_id}", :name => 'DELETE ME'}}
    res = @dapi.make_api_call(endpoint_url, http_method, options_hash)

    assert_equal @org_id, res['organizationId']
  end

  def test_it_asserts_when_bad_network_id_on_put
    assert_raises '404 returned. Are you sure you are using the proper IDs?' do
      endpoint_url = "/networks/11111"
      http_method = 'PUT'

      options_hash = {:headers => {"Content-Type" => 'application/json'}, :body => {:name => 'test_network_renamed2'}}
      res = @dapi.make_api_call(endpoint_url, http_method, options_hash)
    end
  end

  def test_it_can_delete
    endpoint_url = "/networks/#{@test_network_id}"
    http_method = 'DELETE'

    res = @dapi.make_api_call(endpoint_url, http_method)
  end

end
