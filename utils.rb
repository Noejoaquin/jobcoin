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

def get_address_balance(address) #returns a string
  res = HTTParty.get(API_ADDRESS_URL + address)
  JSON.parse(res.body)["balance"]
end

def get_address_transactions(address) #returns an array of transactions
  res = HTTParty.get(API_ADDRESS_URL + address)
  JSON.parse(res.body)["transactions"]
end

def last_transaction_for(address) #returns a hash of the last transaction
  all_trans = get_address_transactions(address)
  all_trans.last
end

def get_all_transactions #returns an array of all transactions
  res = HTTParty.get(API_TRANSACTIONS_URL)
  JSON.parse(res.body)
end

def transfer_funds(from:, to:, amt:) #returns "OK"
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

puts get_address_transactions("001fb6d7")
