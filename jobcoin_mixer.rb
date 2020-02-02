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

  def add_transaction(deposit_address ,options)
    mixer_struct = create_struct(options)
    puts "------------"
    puts "mixer_struct: #{mixer_struct}"
    puts "------------"
    #change this name
    @deposits_to_check_and_move = @deposits_to_check_and_move.merge(
      { deposit_address => mixer_struct }
    )
  end

  def listen
    while !@deposits_to_check_and_move.empty?
      deposits_to_check_and_move.each do |deposit_address, mixer_struct| #implement the struct here...
        timestamp = mixer_struct.timestamp
        transaction = find_transaction(deposit_address, timestamp) #still valid, we want to make sure it got there!
        next if transaction.empty?
        puts "#{transaction}"
        mixer_struct.total_amt = transaction["amount"]
        transfer_to_house(deposit_address, mixer_struct)
        remove_address(deposit_address)
      end
      sleep(1)
    end
  end

  def distribute_for_withdrawal
    zero_amount_count = 0
    until zero_amount_count == @house.length
      @house.each do |mixer_struct, amt_left|
        if amt_left.to_f < 1 # transfer remainder to whichever account
          receiving_acct = mixer_struct.withdrawal_addresses.first
          JobcoinClient.transfer_funds(from: HOUSE_ADDRESS, to: receiving_acct, amt: amt_left.to_f)
          @house[mixer_struct] = "0"
          zero_amount_count += 1
        else
          withdrawal_accts = mixer_struct.withdrawal_addresses
          new_amt_remaining = distribute_percentage(withdrawal_accts, amt_left)
          @house[mixer_struct] = new_amt_remaining
        end
      end
    end
  end

  def display_receipts
    completed_mixes = @house.keys
    completed_mixes.each do |mixer_struct|
      balances = get_balances(mixer_struct.withdrawal_addresses)
      # create_receipt(balances)
      puts  "Initial Deposit of #{mixer_struct.total_amt} from #{mixer_struct.user_address}\n
      distributed to the following addresses:"
      create_receipt(balances).each do |line|
        puts "#{line}"
      end
      puts "-------------------"
    end
  end

  private

  def create_receipt(balances)
    balances.map do |balance|
      "address #{balance[:address]} has #{balance[:amount]} Jobcoin"
    end
  end

  def get_balances(addresses)
    addresses.map do |address|
      balance = JobcoinClient.get_address_balance(address)
      {address: address, amount: balance}
    end
  end

  MixerStruct = Struct.new(
    :user_address,
    :withdrawal_addresses,
    :total_amt,
    :timestamp
  )
  def create_struct(options)
    MixerStruct.new(
      options[:user_address],
      options[:withdrawal_addresses],
      options[:total_amt],
      options[:timestamp]
    )
  end

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

  def transfer_to_house(deposit_address, mixer_struct)
    puts "transferring to the big house, whoooooohoooooo"
    status = JobcoinClient.transfer_funds(
      from: deposit_address,
      to: HOUSE_ADDRESS,
      amt: mixer_struct.total_amt
    )
    puts "status: #{status}"
    @house[mixer_struct] = mixer_struct.total_amt if status == "OK"
  end
end
