require './test/test_helper'

class AdminsTest < Minitest::Test
  def test_it_lists_the_dashboard_admins

    res = @dapi.list_admins(@org_id)

    assert_kind_of Array, res
  end

  def test_it_can_create_admins
    delete_admin
    begin
      # create a random email username
      options = {:email => "delete-me#{rand(36**10).to_s(36)}@example.com", :name => 'delete me',
                          :orgAccess => 'read-only'}
      res = @dapi.add_admin(@org_id, options)
    rescue => e
      puts e
      delete_admin if e.message.include?('is already registered')
      retry
    end

    assert_kind_of Hash, res
    assert_match /delete/, res['email']
  end


  def test_it_can_update_an_admin

      options = {:name => 'updated admin'}
      res = @dapi.update_admin(@org_id, @admin_id, options)

      assert_kind_of Hash, res
      assert_equal options[:name], res['name']
    end

  def test_it_can_revoke_an_admin

    res = @dapi.revoke_admin(@org_id, @admin_id)

    assert_equal 204, res.code
  end

end
