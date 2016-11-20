# Dashboard API v1.0.0
[![Build Status](https://travis-ci.org/jletizia/dashboardapi.svg?branch=master)](https://travis-ci.org/jletizia/dashboardapi)
[![Coverage Status](https://coveralls.io/repos/github/jletizia/dashboardapi/badge.svg?branch=master)](https://coveralls.io/github/jletizia/dashboardapi?branch=master)
[![Code Climate](https://codeclimate.com/github/jletizia/dashboardapi/badges/gpa.svg)](https://codeclimate.com/github/jletizia/dashboardapi)

Documentation: [here](http://www.rubydoc.info/gems/dashboard-api/1.0.0)

Issues: [here](https://github.com/jletizia/dashboardapi/issues)

# Description
A ruby implementation of the entire [Meraki Dashboard API](https://documentation.meraki.com/zGeneral_Administration/Other_Topics/The_Cisco_Meraki_Dashboard_API)

# Usage
## Installation
```bash
gem install dashboard-api
```

Once the gem is installed, you can use it by requiring `dashboard-api`
```ruby
require 'dashboard-api'
```
## Examples

### Basic implementation
#### Get a list of networks for a specific Dashboard Organization

```ruby
# get_networks.rb
require 'dashboard-api'

# read in API key and Org ID from Environment variables
@dashboard_api_key = ENV['dashboard_api_key']
@dashboard_org_id = ENV['dashboard_org_id']

dapi = DashboardAPI.new(@dashboard_api_key)
dapi.get_networks(@dashboard_org_id)
```

#### Update a specific network
This will update a specific network to have the new name of `New VPN Spoke`. Note the options hash, `network_options`. Whenever making a call to something that updates
Dashboard, an options hash will be used, with all necessary attributes as keys. Specifics about these keys can be found in the official [Meraki API Documentation](https://dashboard.meraki.com/manage/support/api_docs).
```ruby
# update_network.rb
require 'dashboard-api'

# read in API key and Org ID from Environment variables
@dashboard_api_key = ENV['dashboard_api_key']
@dashboard_org_id = ENV['dashboard_org_id']
@network_id = ENV['combined_network']

dapi = DashboardAPI.new(@dashboard_api_key)

network_options = {:id => @network_id, :name => 'New VPN Spoke'}
dapi.update_network(@network_id, network_options)
```


# Contributing
**UPDATE**: The testing infrastructure is currently being rewritten to minimize dependencies (ENV vars, etc.), and allow a much easier time when running tests for the first time. Should be done shortly. (11/19/2016)

If you feel like contributing, information about the testing environment can be found below. If you just want to use the gem to help interact with the Meraki Dashboard,
you only need to read the above sections.

## Dependencies
To install the necessary dependencies run:
```bash
bundle install
```
or

```bash
gem install --dev dashboard-api
```
or look in the `Gemfile` and install each dependency individually.

## Testing
Because the Dashboard API needs actual Dashboard resources to hit against, there is a decent amount of pre-configuring that needs to go into place. This includes not only setting your API key, a default organization ID, etc. but also setting up test devices that will be modified, removed, claimed, etc. on Dashboard. It is recommended to use a completely separate test organization, with separate test devices if possible, as to not potentially disturb a production organization.

### Environment Variables
Each test file will read in the necessary ENV variables for it's specifc set of tests:
```ruby
class OrganizationsTest < Minitest::Test
  def setup
    @dashboard_api_key = ENV['dashboard_api_key']
    @org_id = ENV['dashboard_org_id']
    @network_id = ENV['test_network_id']
    @dapi = DashboardAPI.new(@dashboard_api_key)
  end
```
The full list of necessary ENV variables is:
* `dashboard_api_key` Your Meraki Dashboard API key
* `dashboard_org_id` The Meraki Dashboard Organization ID you will be testing on
* `test_network_id` A test network ID that will be used to test renaming networks
* `vpn_network` A test MX network that will test modifying AutoVPN settings
* `switch_network` A test MS netwok that will test things like access policies, etc.
* `mx_serial` A test MX that has client traffic passing through it
* `spare_mr` A test MR used to claim in and out of networks
* `test_admin_id` The ID of a test admin used to test updating and deleting admins
* `config_template_id` A test configuration template network ID used to test removing a template
* `unclaimed_device` A device that can be used to test claiming
* `phone_network` Test phone network
* `phone_contact_id` Test contact for your phone network
* `saml_id` ID of a test SAML user
* `config_template_id` ID of the template you will bind the test network to
* `config_bind_network` network you want to bind to a template

### Running a test
As this is an wrapper gem for an RESTful API, the vast majority of methods make some sort of HTTP call. To reduce the amount of time testing takes, and ensure that we have good data to work against at all times, we utilize [VCR](https://github.com/vcr/vcr). This will capture the HTTP interaction the first time a test is ran, save them as fixtures, and then replay that fixture on each subsequent call to that method during tests.

#### First test run issues
Due to the HTTP interactions containing private data we are trying to obscure with environment variables in the first place (API key, organization IDs, etc.), the fixtures used to initially test this gem can not be provided here. This means that you will need to generate your own fixtures. Luckily, this is as easy as just running the tests in the first place. Unluckily, due to Minitest randomizing the order of it's tests, you may run into situations where the test to delete a network runs for the first time, before that network ever exists (remember, with VCR, only the first test run's HTTP interaction is saved, and used for each later test). When this happens, a 404 will be received, VCR will save it, and the test will fail.

#### What this means
Getting all of the tests to a point where they all pass will not be a trivial task, due to the workflow of: running the tests, finding the tests that failed due to a prerequisite not having happened at some point before that test run, fixing the prerequisite, deleting the fixture (they live in `fixtures/vcr_cassettes/`), and rerunning the tests.

#### How to actually run the tests
```
rake test
```

After the first completely successful, all green run, tests will be almost instantenous:

```bash
➜  dashboard-api git:(master) ✗ rake test
Started with run options --seed 42405

DashAPITest
  test_snmp_returns_as_array                                      PASS (0.01s)
  test_license_state_returns_as_hash                              PASS (0.01s)
  test_api_key_is_a_string                                        PASS (0.00s)
  test_get_an_organization                                        PASS (0.01s)
  test_it_returns_as_json                                         PASS (0.00s)
  test_get_inventory_for_an_org                                   PASS (0.01s)
  test_get_license_state_for_an_org                               PASS (0.00s)
  test_third_party_peer_returns_as_array                          PASS (0.01s)
  test_it_is_a_dash_api                                           PASS (0.00s)
  test_current_snmp_status                                        PASS (0.00s)
  test_inventory_returns_as_array                                 PASS (0.00s)
  test_third_party_vpn_peers                                      PASS (0.00s)

Finished in 0.05813s
12 tests, 12 assertions, 0 failures, 0 errors, 0 skips
```
