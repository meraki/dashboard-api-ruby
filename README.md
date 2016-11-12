# Dashboard API
A ruby implementation of the [Meraki Dashboard API](https://documentation.meraki.com/zGeneral_Administration/Other_Topics/The_Cisco_Meraki_Dashboard_API)

# Testing
To install the necessary dependencies run:
```
bundle install
```
If you do not use bundler, you can check out the gemfile, and install the dependencies individually as necessary.

The Meraki dashboard API requires both an API key, as well as certain identifiers such as Organization IDs. If you would like to run the tests,
you currently require 2 Environment variable to be set:

* `dashboard_api_key`
* `dashboard_org_id`

Once those are set and dependencies are installed, you can run the tests with
```
rake test
```

Testing is currently run with [VCR](https://github.com/vcr/vcr) to capture actual HTTP responses to run the tests off of. This requires that the environment variables you set up above are forr a valid Meraki Dashboard Organization. After running the tests for the first time, subsequent test output will look something similar to:
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
