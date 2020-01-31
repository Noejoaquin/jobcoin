require 'minitest/autorun'
require 'json'
require_relative '../jobcoin_client'

class TestJobcoinClient < Minitest::Test
  def test_get_address_balance
    mock = Minitest::Mock
    def mock.body
      {"balance":"27"}.to_json
    end
    HTTParty.stub :get, mock do
      assert_equal "27", JobcoinClient.get_address_balance("address")
    end
  end

  def test_get_address_transactions
    mock = Minitest::Mock
    def mock.body
      {
        "transactions": [
          {
            "timestamp":"fake_date",
            "toAddress":"some_address",
            "amount":"some_number"
          }
        ]
      }.to_json
    end
    HTTParty.stub :get, mock do
      transactions = JobcoinClient.get_address_transactions("address")
      assert_equal 1, transactions.length
      trans = transactions.first
      assert_equal "fake_date", trans["timestamp"]
      assert_equal "some_address", trans["toAddress"]
      assert_equal "some_number", trans["amount"]
    end
  end

  def test_last_transaction_for
    mock = Minitest::Mock
    def mock.body
      {
        "transactions": [
          {"transaction1" => 2}
        ]
      }.to_json
    end

    HTTParty.stub :get, mock do
      transaction = JobcoinClient.last_transaction_for("address")
      assert_equal 1, transaction.length
    end
  end

  def test_get_all_transactions
    mock = Minitest::Mock
    def mock.body
      {
        "transactions": [
          {"transaction1":"boom"},
          {"transaction2":"chicka"},
          {"transaction3":"boom"},
        ]
      }.to_json
    end
    HTTParty.stub :get, mock do
      transactions = JobcoinClient.get_all_transactions
      assert_equal 3, transactions.length
    end
  end

  def test_transfer_funds
    mock = Minitest::Mock
    def mock.body
      {"status":"OK"}.to_json
    end
    HTTParty.stub :post, mock do
      assert_equal "OK", JobcoinClient.transfer_funds(from: "Homer", to: "Bart", amt: "2")
    end
  end
end
