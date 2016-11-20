require './test/test_helper'

class NetworksTest < Minitest::Test
  def test_it_can_get_networks
    res = @dapi.get_networks(@org_id)

    assert_kind_of Array, res
  end

  def test_it_can_get_a_single_network
    res = @dapi.get_single_network(@test_network_id)

    assert_kind_of Hash, res
    assert_equal 'DELETE ME', res['name']
  end

  def test_it_can_update_a_network
    options = {:id => @test_network_id, :organizationId => @org_id, :tags => 'this_is_a_new_tag'}

    res = @dapi.update_network(@test_network_id, options)

    # not sure why the response contains leading and trailing spaces
    # nothing to worry about as it does not show up like this in Dashboard
    assert_equal ' this_is_a_new_tag ', res['tags']
  end

  def test_options_are_a_hash_update_network
    assert_raises "Options were not passed as a Hash" do
      @dapi.update_network('123456', 'option')
    end
  end

  def test_it_can_create_a_network
    begin
      options = {:name => 'DELETE ME', :type => 'wireless'}
      res = @dapi.create_network(@org_id, options)
    rescue => e
      delete_empty_test_network if e.message.include?('Name has already been taken')
      retry
    end

    assert_equal 'DELETE ME', res['name']
  end

  def test_options_are_a_hash_create_network
    assert_raises 'Options were not passed as a Hash' do
      @dapi.update_network(@network_id, 'option')
    end
  end

  def test_delete_a_single_network
    res = @dapi.delete_network(@test_network_id)

    assert_equal true, res
  end

  def test_get_s2s_vpn_settings
    res = @dapi.get_auto_vpn_settings(@test_network_id)

    assert_kind_of Hash, res
  end

  def test_update_s2s_vpn_settings
    options = {:mode => 'none'}

    res = @dapi.update_auto_vpn_settings(@test_network_id, options)

    assert 'none', res['mode']
    assert_kind_of Hash, res
  end

  def test_get_ms_access_policies_for_network
    create_empty_test_network('switch')
    res = @dapi.get_ms_access_policies(@test_network_id)

    # this assumes there are no policies configured
    assert_equal [] , res
  end

  def test_it_can_bind_a_network_to_a_template
    create_empty_test_network('switch')
    template = get_specific_template('Permanent')

    options = {:configTemplateId => template['id']}
    res = @dapi.bind_network_to_template(@test_network_id, options)

    assert_equal 200, res
  end

  def test_it_can_unbind_a_network_to_a_template
    create_empty_test_network('switch')

    template = get_specific_template('Permanent')

    options = {:configTemplateId => template['id']}
    @dapi.bind_network_to_template(@test_network_id, options)

    res = @dapi.unbind_network_to_template(@test_network_id)
    assert_equal 200, res
  end

  # def test_it_can_return_traffic_analytics
  #   VCR.use_cassette('traffic_analysis_data') do
  #     options = {:timespan => 7200}
  #     res = @dapi.traffic_analysis(@combined_network, options)
  #
  #     assert_kind_of Array, res
  #   end
  # end
end
