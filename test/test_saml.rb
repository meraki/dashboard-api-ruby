require './test/test_helper'

class SAMLTest < Minitest::Test
  def test_it_can_list_saml_roles
    res = @dapi.list_saml_roles(@org_id)
    assert_kind_of Array, res
  end

  def test_it_can_return_a_single_saml_role
    res = @dapi.return_saml_role(@org_id, @saml_id)

    assert_kind_of Hash, res
    assert_equal @saml_id, res['id']
  end

  def test_it_can_create_saml_roles
    options = { role: 'API_TEST_ROLE_2', orgAccess: 'read-only' }
    res = @dapi.create_saml_role(@org_id, options)

    assert_kind_of Hash, res
    assert_equal options[:role], res['role']
  end

  def test_it_can_update_saml_roles
    options = { role: 'API_TEST_ROLE_UPDATED', orgAccess: 'read-only' }
    res = @dapi.update_saml_role(@org_id, @saml_id, options)

    assert_kind_of Hash, res
    assert_equal options[:role], res['role']
  end

  def test_it_can_remove_saml_role
    res = @dapi.remove_saml_role(@org_id, @saml_id)

    assert_equal 204, res.code
  end
end
