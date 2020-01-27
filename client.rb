require('net/http')
# Urls
API_BASE_URL = "http://jobcoin.gemini.com/pauper-jackpot/api"
API_ADDRESS_URL = "#{API_BASE_URL}/addresses/"
API_TRANSACTIONS_URL = "#{API_BASE_URL}/transactions/"


def getAddressInfo(address)
  url = API_ADDRESS_URL + address
  uri = URI(url)
  res = Net::HTTP.get(uri)
  puts res
end


getAddressInfo("NoesAddress1")
