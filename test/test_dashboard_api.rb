require 'minitest/autorun'
require './lib/dashboard_api.rb'
require 'minitest/reporters'
require 'vcr'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

VCR.configure do |config|
    config.cassette_library_dir = "fixtures/vcr_cassettes"
    config.hook_into :webmock # or :fakeweb
end

class DashAPITest < Minitest::Test
  def setup
    @dashboard_api_key = ENV['dashboard_api_key']
    @org_id = ENV['dashboard_org_id']

    @dapi = DashboardAPI.new(@dashboard_api_key)
  end

  def test_it_is_a_dash_api
    assert_kind_of DashboardAPI, @dapi
  end

  def test_api_key_is_a_string
    assert_kind_of String, @dapi.key
  end
end
