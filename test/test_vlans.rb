require './test/test_helper'

class VLANsTest < Minitest::Test
  def test_it_lists_the_vlans
    VCR.use_cassette('list_the_vlans') do
      res = @dapi.list_vlans(@combined_network)

      assert_kind_of Array, res
    end
  end

  def test_it_returns_a_vlan
    VCR.use_cassette('return_a_vlan') do
      res = @dapi.return_vlan(@combined_network, 10)

      assert_kind_of Hash, res
      assert_equal 10, res['id']
    end
  end

  def test_it_adds_a_vlan
    VCR.use_cassette('add_a_vlan') do
      options = {:id => 456, :name => 'api_vlan', :subnet => '192.168.123.0/30',
                 :applianceIp => '192.168.123.1'}
      res = @dapi.add_vlan(@combined_network, options)

      assert_kind_of Hash, res
      assert_equal options[:id], res['id']
    end
  end

  def test_options_is_hash_add_vlan
    assert_raises 'Options were not passed as a hash' do
      @dapi.add_a_vlan(@combined_network, 'abc')
    end
  end

  def test_it_updates_a_vlan
    VCR.use_cassette('update_a_vlan') do
      options = {:name => 'api_vlan_updated'}
      res = @dapi.update_vlan(@combined_network, 456, options)

      assert_kind_of Hash, res
      assert_equal options[:name], res['name']
    end
  end

  def test_options_is_hash_add_vlan
    assert_raises 'Options were not passed as a hash' do
      @dapi.update_a_vlan(@combined_network, 456, 'abc')
    end
  end

  def test_it_deletes_a_vlan
    VCR.use_cassette('delete_a_vlan') do
      res = @dapi.delete_vlan(@combined_network, 456)

      assert_equal 204, res.code
    end
  end
end
