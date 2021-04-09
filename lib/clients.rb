# frozen_string_literal: true

# Clients section of the Meraki Dashboard API
# @author Joe Letizia
module Clients
  # Return client usage for a specific device
  # @param [String] serial meraki serial number of the device
  # @param [Integer] timespan timespan up to 1 month in seconds to get client usage for
  # @return [Array] an array of hashes for each client's usage
  def get_client_info_for_device(serial, timespan)
    raise 'Timespan can not be larger than 2592000 seconds' if timespan.to_i > 2_592_000

    make_api_call("/devices/#{serial}/clients?timespan=#{timespan}", :get)
  end
end
