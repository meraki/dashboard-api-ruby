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
### Prerequisites
There are a few prerequisites if you want to be able to run tests (at least for the first time, until fixtures get generated). These are split up into Dashboard and Environment Variables:
#### Dashboard configuration
* A combined network that should have
  * an MX, with VLANs enabled
  * an MS
  * an MR, with the first SSID
* a single network called 'DELETE ME' exists
* A single template called 'API Delete Me' already exists
* A single template exists called 'API Permanent'
#### Environment Variables
* `dashboard_api_key` Your Meraki Dashboard API key
* `org_id` The Meraki Dashboard Organization where you will be testing on
* `combined_network` The combined network set up in the above requirements
* `ms_serial` The serial number of the MS in the combined network. Used to test switchport methods
* `unclaimed_device` A device that is unclaimed. Used to test claining into an org / network.

### Running a test
As this is a wrapper gem for an RESTful API, the vast majority of methods make some sort of HTTP call. To reduce the amount of time testing takes, and ensure that we have good data to work against at all times, we utilize [VCR](https://github.com/vcr/vcr). This will capture the HTTP interaction the first time a test is ran, save them as fixtures, and then replay that fixture on each subsequent call to that method during tests.

**NOTE**: This means that if you happen to have things misconfigured, run a test, and receive a 404, that 404 response is now saved for that test. You will need to manually remove it from `fixtures/vcr_cassettes` and rerun the test.

#### How to actually run the tests
```
rake test without-secrets
```
#### Without secrets?
Running the rake test with the `without-secrets` options tells VCR not to obfuscate any sensitive information when creating fixtures (sensitive information being described as the ENVs listed below). This is OK for 99.99% of the normal use cases (such as feature development on a local machine). The reason the functionality to allow for the obfuscation is for the potential down the line to be able to release a current "working set" of fixtures, so that you don't need to have an entire Dashboard Organization set up to modify existing methods and test them.

If you want to run your local tests with secret obfuscation for any reason, you need the following ENV variables set:
```
['secret_dashboard_api_key', 'secret_dashboard_org_id', 'secret_ms_serial', 'secret_unclaimed_device', 'secret_combined_network', 'secret_first_name', 'secret_last_name',
           'secret_email', 'secret_admin_id', 'secret_shard_id']
```

### Test results
After the first completely successful, all green run, subsequent tests will be almost instantaneous:

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
