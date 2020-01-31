require_relative 'utils'
require_relative 'jobcoin_client'

class JobCoinMixer
  attr_reader :deposits_to_check_and_move, :house
  HOUSE_ADDRESS = "HouseTest".freeze
  PERCENTAGE_TO_SEND = 0.40

  def initialize
    @deposits_to_check_and_move = {}
    @house = {}
  end

  def add_transaction(transaction)
    @deposits_to_check_and_move = @deposits_to_check_and_move.merge(transaction)
  end

  def listen
    while !@deposits_to_check_and_move.empty?
      # { "deposit_address" => ["timestamp",["user", "addresses"]] }
      deposits_to_check_and_move.each do |deposit_address, values|
        timestamp, user_addresses = values[0], values[1]
        transaction = find_transaction(deposit_address, timestamp)
        next if transaction.empty?
        puts "#{transaction}"
        transfer_to_house(deposit_address, transaction["amount"], user_addresses)
        remove_address(deposit_address)
      end
      sleep(1)
    end
  end

  def distribute_for_withdrawal # test this out
    zero_amount_count = 0
    until zero_amount_count == @house.length
      @house.each do |accounts, amount|
        if amount.to_f < 1 # transfer remainder to whichever account
          JobcoinClient.transfer_funds(from: HOUSE_ADDRESS, to: accounts.first, amt: amount)
          @house[accounts] = "0"
          zero_amount_count += 1
        else
          remaining_amount = distribute_percentage(accounts, amount)
          @house[accounts] = remaining_amount
        end
      end
    end
  end

  def display_receipts
    puts 'I got DEM RECEIPTS'
  end

  private

  def distribute_percentage(accounts, amt) # dolls out fixed % of remaining amount to random account
      random_idx = rand(0...accounts.length)
      addrs_to_send = accounts[random_idx]
      amt_to_send = amt.to_f * PERCENTAGE_TO_SEND
      JobcoinClient.transfer_funds(from: HOUSE_ADDRESS, to: addrs_to_send, amt: amt_to_send.to_s)
      (amt.to_f - amt_to_send).to_s
  end

  def remove_address(address)
    @deposits_to_check_and_move.delete(address)
  end

  def find_transaction(deposit_address, timestamp)
    transactions = JobcoinClient.get_address_transactions(deposit_address)
    puts "transactions: #{transactions}"
    puts "transactions class: #{transactions.class}"
    transactions.find do |trans|
      trans["timestamp"] == timestamp
    end
  end

  def transfer_to_house(deposit_address, amount, user_addresses)
    puts "transferring to the big house, whoooooohoooooo"
    status = JobcoinClient.transfer_funds(from: deposit_address, to: HOUSE_ADDRESS, amt: amount)
    puts "status: #{status}"
    @house[user_addresses] = amount if status == "OK"
  end
end
