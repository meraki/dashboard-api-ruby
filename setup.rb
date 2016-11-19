#!/usr/bin/env ruby
require 'dashboard-api'

@dapi = DashboardAPI.new('87341c8f9df7bc09d6415de2c4d38bcc122fda41')
@org_id = '613052499275809112'
@vars = {}

def create_deletion_network
  options = {:name => 'DELETE ME', :type => 'wireless'}
  @vars[:deletion_network] = @dapi.create_network(@org_id, options)['id']
rescue => e
  puts "Network not created due to #{e}"
end

def create_

def vars
  @vars = {:mx_serial => 'Q2QN-F5PZ-UEJC',
          :mr_serial => 'Q2DD-C57G-28MX',
          :ms_serial => 'Q2CP-HKJL-T3M8',
          :unclaimed_device_serial => 'Q2HP-VWQH-CZWG',
          :org_id => '613052499275809112',
          :combined_network => 'L_613052499275810976',
          :vpn_network => 'L_613052499275810976',
          :switch_network => 'L_613052499275810976',
          :test_network_id => 'L_613052499275810976',

  }
end

vars
create_deletion_network
puts @vars
