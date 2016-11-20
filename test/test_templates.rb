require './test/test_helper'

class TemplatesTest < Minitest::Test
  def test_it_can_list_an_orgs_templates
    res = @dapi.list_templates(@org_id)
    assert_kind_of Array, res
  end

  def test_it_can_remove_a_template
    begin
      @config_template_id = get_specific_template('Delete Me')['id']
    rescue => e
      puts e
      skip "It doesn't look like you have a template to delete..."
    end
    res = @dapi.remove_template(@org_id, @config_template_id)
    assert_equal 204, res.code
  end
end
