require './test/test_helper'

class TemplatesTest < Minitest::Test
  def test_it_can_list_an_orgs_templates
    VCR.use_cassette('list_all_templates') do
      res = @dapi.list_templates(@org_id)

      assert_kind_of Array, res
    end
  end

  def test_it_can_remove_a_template
    VCR.use_cassette('remove_a_template') do
      res = @dapi.remove_template(@org_id, @config_template_id)

      assert_equal 204, res.code
    end
  end
end
