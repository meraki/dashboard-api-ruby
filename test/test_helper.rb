require 'minitest'
require 'minitest/autorun'
require 'faraday'
require_relative '../lib/dashboard_api.rb'
require_relative '../lib/base_request.rb'
class TestDashboardAPI < Minitest::Test
  def setup
    super
    @dapi = DashboardAPI.new()
  end
end

class TestBaseRequest < Minitest::Test
  def setup
    super
    @base_request = BaseRequest.new()
  end
end
