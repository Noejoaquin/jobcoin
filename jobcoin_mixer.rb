class JobCoinMixer
  attr_reader :deposit_address_transactions

  def initialize
    @deposit_address_transactions = {}
    # @big_house = { num => user_addresses }
  end

  def add_transaction(transaction)
    @deposit_address_transactions = @deposit_address_transactions.merge(transaction)
  end

  def listen

    #when money arrives in accounts, transfer to the big house
  end

  def add_deposit_account_and_user_addresses(dep, addresses)
    #add account and addresses to the class variable
  end

  private

  def transfer_to_big_house
    #transfer money to big house
    #doll out
  end

  def doll_out

  end
end
