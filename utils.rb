require 'digest'
require 'date'
require 'json'
require 'httparty'
require_relative 'client'

def generate_deposit_address # this is creating the deposit address that the mixer owns
  hash = Digest::SHA256.new
    .update(DateTime.now.strftime('%Q')) # This allows for update using miliseconds since 1970
    .hexdigest
  hash[0..7]
end

def get_address_balance(address)
  res = HTTParty.get(API_ADDRESS_URL + address)
  JSON.parse(res.body)["balance"]
end

def get_address_transactions(address)
  res = HTTParty.get(API_ADDRESS_URL + address)
  JSON.parse(res.body)["transactions"]
end

def last_transaction_for(address)
  all_trans = get_address_transactions(address)
  all_trans.last
end

def get_all_transactions
  res = HTTParty.get(API_TRANSACTIONS_URL)
  JSON.parse(res.body)
end

def transfer_funds(from, to, amt)
  res = HTTParty.post(
    API_TRANSACTIONS_URL,
    body: {
      fromAddress: from,
      toAddress: to,
      amount: amt
    }
  )
  res["status"]
end

# puts last_transaction_for("NoesAddress1").class
