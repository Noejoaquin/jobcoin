require_relative 'utils'

class JobCoinMixer
  attr_reader :deposits_to_check_and_move
  HOUSE_ADDRESS = "HouseTest".freeze

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

  private

  def remove_address(address)
    @deposits_to_check_and_move.delete(address)
  end

  def find_transaction(deposit_address, timestamp)
    transactions = get_address_transactions(deposit_address)
    puts "transactions: #{transactions}"
    puts "transactions class: #{transactions.class}"
    transactions.find do |trans|
      trans["timestamp"] == timestamp
    end
  end

  def transfer_to_house(deposit_address, amount, user_addresses)
    puts "transferring to the big house, whoooooohoooooo"
    status = transfer_funds(from: deposit_address, to: HOUSE_ADDRESS, amt: amount)
    puts "status: #{status}"
    @house[user_addresses] = amount if status == "OK"
  end

  def doll_out

  end
end
