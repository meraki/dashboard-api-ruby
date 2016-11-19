require './test/test_helper'

class PhonesTest < Minitest::Test
  def test_it_can_list_contacts
    VCR.use_cassette('list_phone_contacts') do
      res = @dapi.list_phone_contacts(@phone_network)

      assert_kind_of Array, res
    end
  end

  def test_it_can_add_a_contact
    VCR.use_cassette('add_a_phone_contact') do
      options = {:name => 'api test'}
      res = @dapi.add_phone_contact(@phone_network, options)

      assert_kind_of Hash, res
      assert_equal options[:name], res['name']
    end
  end

  def test_it_can_update_a_contact
    VCR.use_cassette('update_a_phone_contact') do
      options = {:name => 'updated test'}
      res = @dapi.update_phone_contact(@phone_network, @contact_id, options)

      assert_kind_of Hash, res
      assert_equal options[:name], res['name']
    end
  end

  def test_it_can_delete_a_contact
    VCR.use_cassette('delete_a_phone_contact') do
      res = @dapi.delete_phone_contact(@phone_network, @contact_id)

      assert_equal 204, res.code
    end
  end

end
