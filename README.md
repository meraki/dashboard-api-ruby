# Dashboard API v0.3.0
A ruby implementation of the [Meraki Dashboard API](https://documentation.meraki.com/zGeneral_Administration/Other_Topics/The_Cisco_Meraki_Dashboard_API)

Documentation [here](http://www.rubydoc.info/gems/dashboard-api/0.3.0)

# Preface
The following readme is broken down into two sections:
  * Installing / Usage of the gem
  * Contributing to development of the gem

# Installation and Normal Usage
## Usage
```bash
gem install dashboard-api
```
Once the gem is installed, you can use it by requiring `dashboard-api`
```
require 'dashboard-api'
 => true 
```

## Examples
It is highly recommended that you utilize environment variables when dealing with things like API keys, tokens, etc. instead of utilizing them directly in a script. All examples will be shown with this convention.

###Instantiating a new instance:
```ruby
dapi = DashboardAPI.new(ENV['dashboard_api_key'])
```

###Listing details about a specific network:
```ruby
dapi.get_single_network(ENV['vpn_network'])
 => {"id"=>"N_<OMITTED>", "organizationId"=>"<OMITTED>", "type"=>"appliance", "name"=>"vpn_test_network", "timeZone"=>"America/Los_Angeles", "tags"=>""}
```
There are many times where you need to actually pass data up to the Dashboard API, be it for creating new networks, updating device information, etc. In situations like these, an options hash is expected
to be passed alongside to the method call. The Dashboard-API gem documentation mentions what is expected in the option hash for methods that require it, but the offical [Meraki Dashboard API documentation](https://dashboard.meraki.com/manage/support/api_docs) is recommended for exact details.

###Creating a new network:
```ruby
options = {:name => 'new_test_network', :type => 'wireless'}
 => {:name=>"new_test_network", :type=>"wireless"} 
dapi.create_network(ENV['dashboard_org_id'], options)
 => {"id"=>"N_<OMITTED>", "organizationId"=>"<OMITTED>", "type"=>"wireless", "name"=>"new_test_network", "timeZone"=>"America/Los_Angeles", "tags"=>""} 
```

Not every method call will return a Hash object. Some will return an Array, often containing a Hash in each element. Information about what is expected to be returned can be found in the Dashboard-API Documentation, as well as the official Meraki Dashboard API help documentation.

```ruby
dapi.get_third_party_peers(ENV['dashboard_org_id'])
 => [{"name"=>"test_api_peer", "publicIp"=>"10.0.0.1", "privateSubnets"=>["10.1.0.0/24"], "secret"=>"password", "tags"=>["all"]}, {"name"=>"second_api_peerr", "publicIp"=>"10.0.0.2", "privateSubnets"=>["10.2.0.0/24"], "secret"=>"password", "tags"=>["api_test"]}] 
```

# Development
## Testing
To install the necessary dependencies run:
```
bundle install
```
If you do not use bundler, you can check out the gemfile, and install the dependencies individually as necessary.

The Meraki Dashboard API requires both an API key, as well as certain identifiers such as Organization, or Network IDs. If you would like to run the full current test suite, the following
ENV variables need to be set:

* `dashboard_api_key` Your Meraki Dashboard API key
* `dashboard_org_id` The Meraki Dashboard Organization ID you will be testing on
* `test_network_id` A test network ID that will be used to test renaming networks
* `vpn_network` A test MX network that will test modifying AutoVPN settings
* `switch_network` A test MS netwok that will test things like access policies, etc.
* `mx_serial` A test MX that has client traffic passing through it
* `spare_mr` A test MR used to claim in and out of networks
* `test_admin_id` The ID of a test admin used to test updating and deleting admins
* `config_template_id` A test configuration template network ID used to test removing a template
It is recommended that you set up a test organization with test devices in it when working with developing new functionality to this gem, as to not potentially disturb any of your production networks.

Once those are set and dependencies are installed, you can run the tests with
```
rake test
```

As the majority of the testing for this gem requires HTTP calls, testing is currently run with [VCR](https://github.com/vcr/vcr) to capture actual HTTP responses to run the tests off of. This requires that the environment variables you set up above are for a valid Meraki Dashboard Organization. After running the tests for the first time, subsequent tests will be ran off of the saved output. We would also expect subsequent test runs to be close to instantenous, as seen below:

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

All of the saved HTTP responses from VCR will be saved by default in `fixtures/vcr_cassettes/`. These **should not be added / comitted to git** as they will contain all of the keys / tokens we set as ENV variables above.
