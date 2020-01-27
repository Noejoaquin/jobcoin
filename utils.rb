require 'digest'
require 'date'

def generate_deposit_address # this is creating the deposit address that the mixer owns
  hash = Digest::SHA256.new
    .update(DateTime.now.strftime('%Q')) # This allows for update using miliseconds since 1970
    .hexdigest
  hash[0..7]
end
