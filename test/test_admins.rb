require './test/test_helper'

class AdminsTest < Minitest::Test
  def test_it_lists_the_dashboard_admins
    VCR.use_cassette('list_admins') do
      res = @dapi.list_admins(@org_id)

      assert_kind_of Array, res
    end
  end

  def test_it_can_create_admins
    VCR.use_cassette('add_admin') do
      options = {:email => 'api-admin@example.com', :name => 'example admin',
                 :orgAccess => 'none'}
      res = @dapi.add_admin(@org_id, options)

      assert_kind_of Hash, res
    end
  end

  def test_it_can_update_an_admin
    VCR.use_cassette('update_admin') do
      options = {:name => 'updated admin'}
      res = @dapi.update_admin(@org_id, @test_admin_id, options)

      assert_kind_of Hash, res
      assert_equal options[:name], res['name']
    end
  end

  def test_it_can_revoke_an_admin
    VCR.use_cassette('revoke_admin') do
      res = @dapi.revoke_admin(@org_id, @test_admin_id)

      assert_equal 204, res.code
    end
  end

end
