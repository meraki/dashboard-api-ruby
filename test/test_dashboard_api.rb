require_relative './test_helper.rb'

class TestDashboardAPI < Minitest::Test
  def test_it_is_a_Dashboard_API
    assert_kind_of DashboardAPI, @dapi
  end

  def test_it_defines_methods
    assert DashboardAPI.instance_methods.include?(:admins_index)
  end

  def test_it_handles_dynamic_arguments_one_arg
    # should raise an exception if no arguments are passed (expects 1)
    assert_raises ArgumentError do
      @dapi.admins_index
    end
  end

  def test_it_handles_dynamic_arguments_two_args
    # should raise an exception if only one argument is passed (expects 2)
    assert_raises ArgumentError do
      @dapi.admins_update('first_arg')
    end
  end
end
