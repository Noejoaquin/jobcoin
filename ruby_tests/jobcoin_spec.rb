require 'minitest/autorun'
require 'json'
require_relative '../utils'

class TestUtils < Minitest::Test
  def test_generate_deposit_address
    deposit_address = generate_deposit_address
    assert_kind_of(String, deposit_address)
    assert_equal(8, deposit_address.length)
  end

  def test_get_address_balance
    mock = Minitest::Mock
    def mock.body
      body = {"balance":"27"}.to_json
    end
    HTTParty.stub :get, mock do
      assert_equal "27", get_address_balance("address")
    end
  end

  def test_get_address_transactions
    mock = Minitest::Mock
    def mock.body
      body = {
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
      transactions = get_address_transactions("address")
      assert_equal 1, transactions.length
      trans = transactions.first
      assert_equal "fake_date", trans["timestamp"]
      assert_equal "some_address", trans["toAddress"]
      assert_equal "some_number", trans["amount"]
    end
  end

  def test_get_all_transactions
    mock = Minitest::Mock
    def mock.body
      body = {
        "transactions": [
          {"transaction1":"boom"},
          {"transaction2":"chicka"},
          {"transaction3":"boom"},
        ]
      }.to_json
    end
    HTTParty.stub :get, mock do
      transactions = get_all_transactions
      assert_equal 3, transactions.length
    end
  end

  def test_transfer_funds
    mock = Minitest::Mock
    def mock.body
      {"status":"OK"}.to_json
    end
    HTTParty.stub :post, mock do
      assert_equal "OK", transfer_funds(from: "Homer", to: "Bart", amt: "2")
    end
  end
end
