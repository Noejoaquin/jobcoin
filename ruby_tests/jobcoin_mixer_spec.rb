require 'minitest/autorun'
require_relative '../jobcoin_client'
require_relative '../jobcoin_mixer'

describe JobcoinMixer do
  before do
    @jobcoin_mixer = JobcoinMixer.new
    @new_transaction_data = {
      user_address: "from_address",
      withdrawal_addresses: ["pickup1"],
      timestamp: "timestamp",
      total_amt: "10"
    }
    @deposit_address = "194e269f"
    @jobcoin_mixer.add_transaction(@deposit_address, @new_transaction_data)
    @mixer_struct = @jobcoin_mixer.tracked_transactions["194e269f"]
  end

  describe "when a new transaction is added to the mixer" do
    before do
      @new_transaction_data = {
        user_address: "from_address2",
        withdrawal_addresses: ["pickup2"],
        timestamp: "timestamp2",
        total_amt: "5"
      }
      @deposit_address = "868412el"
      @jobcoin_mixer.add_transaction(@deposit_address, @new_transaction_data)
    end
    it "adds a transaction to tracked_transactions" do
      _(@jobcoin_mixer.tracked_transactions.length).must_equal 2
    end
  end

  describe "when the mixer is polling for transactions" do
    before do
      transactions = [
        {"timestamp" => "timestamp", "amount" => "10"}
      ]
      JobcoinClient.stub :get_address_transactions, transactions do
        JobcoinClient.stub :transfer_funds, "OK" do
          @jobcoin_mixer.listen
        end
      end
    end
    it "empties tracked_transactions" do
      _(@jobcoin_mixer.tracked_transactions.empty?).must_equal true
    end

    it "records transaction in house_records" do
      _(@jobcoin_mixer.house.empty?).must_equal false
      _(@jobcoin_mixer.house.length).must_equal 1
      _(@jobcoin_mixer.house[@mixer_struct]).must_equal "10"
    end
  end

  describe "when the mixer is distributing to withdrawal addresses" do
    before do
      @test_struct = JobcoinMixer::MixerStruct.new(
        "user_address101",
        ["withdrawal_addresses1", "withdrawal_addresses2"],
        "40", #total_amt
        "timestamp"
      )
      @jobcoin_mixer.house[@test_struct] = @test_struct.total_amt
      JobcoinClient.stub :transfer_funds, nil do
        @jobcoin_mixer.distribute_for_withdrawal
      end
    end
    it "distributes all funds" do
      _(@jobcoin_mixer.house[@test_struct]).must_equal "0"
    end
  end
end
