require 'minitest'
require 'minitest/autorun'
require 'rest-client'
require_relative '../lib/dashboard_api.rb'
require_relative '../lib/api_client.rb'
class TestDashboardAPI < Minitest::Test
  def setup
    super
    @dapi = DashboardAPI.new('12345')
  end
end

class TestBaseRequest < Minitest::Test
  def setup
    super
    @base_request = BaseRequest.new()
  end
end
