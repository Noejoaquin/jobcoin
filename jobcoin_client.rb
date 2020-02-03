require 'httparty'

API_BASE_URL = "http://jobcoin.gemini.com/pauper-jackpot/api"
API_ADDRESS_URL = "#{API_BASE_URL}/addresses/"
API_TRANSACTIONS_URL = "#{API_BASE_URL}/transactions"


class JobcoinClient
  def self.get_address_balance(address) #returns a string
    res = HTTParty.get(API_ADDRESS_URL + address)
    JSON.parse(res.body)["balance"]
  end

  def self.get_address_transactions(address) #returns an array of transactions
    res = HTTParty.get(API_ADDRESS_URL + address)
    JSON.parse(res.body)["transactions"]
  end

  def self.last_transaction_for(address) #returns a hash of the last transaction
    all_trans = get_address_transactions(address)
    all_trans.last
  end

  def self.transfer_funds(from:, to:, amt:) #returns "OK"
    res = HTTParty.post(
      API_TRANSACTIONS_URL,
      body: {
        fromAddress: from,
        toAddress: to,
        amount: amt
      }
    )
    JSON.parse(res.body)["status"]
  end
end
