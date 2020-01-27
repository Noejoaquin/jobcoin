class JobCoinMixer
  attr_reader :deposit_account, :user_addresses

  def initialize(deposit_account, user_addresses)
    @@deposits_and_addresses = { deposit_account => user_addresses }
    @@big_house = { num => user_addresses }
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
