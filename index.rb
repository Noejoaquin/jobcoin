require_relative 'utils'
require_relative 'jobcoin_mixer'

def prompt(mixer = nil)
  puts "Welcome to the jobcoin mixer!"
  puts "Please enter a comma-separated list of new, unused Jobcoin addresses
  where your mixed Jobcoins will be sent for withdrawal:"

  addresses_for_withdrawal = gets.strip
  new_address_for_deposit = generate_deposit_address

  puts "You may now send Jobcoins to this new deposit address: #{new_address_for_deposit}.
   If you choose, they will be sent to this destination. \n
   Would you like to deposit for future withdrawal?(Enter 'y' for 'yes', or 'n' for 'no')"

  deposit = gets.strip

 if deposit == 'y' || deposit == 'yes'
   puts "Please enter the address from which you will be depositing your jobcoin:"

   from_address = gets.strip
   from_address_balance = get_address_balance(from_address)

   puts "The current balance at #{from_address} is: #{from_address_balance}.
    How much do you want to deposit?"

  deposit_amount = gets.strip

  puts "Are you sure you want to deposit #{deposit_amount} into #{new_address_for_deposit}? (y/n)"
   go_deposit = gets.strip

   if go_deposit == "y"
     transfer_funds(from: from_address, to: new_address_for_deposit, amt: deposit_amount)
     last_trans = last_transaction_for(from_address) #returns hash
     timestamp = last_trans["timestamp"]
     user_addresses = addresses_for_withdrawal.split(",")
     mixer = JobCoinMixer.new unless mixer
     mixer.add_transaction({new_address_for_deposit => [timestamp, user_addresses]})
     puts "Your transaction has been made. Our mixer will now listen, and transfer
     your coins"
     mixer.listen

     puts "your coins have made it to the house account!"
     puts "current balance of the house account: #{get_address_balance("HouseTest")}"
     puts "mixer internal house: #{mixer.house}"
     puts "mixer deposits to check and move: #{mixer.deposits_to_check_and_move}"

     puts "Are there any more deposits you would like to make? (y/n)"
     more_deposits = gets.strip
     if more_deposits == "y"
       prompt(mixer)
     else
       puts "Okay, since there are no other deposits you would like to make,
       we will now distribute your funds to the addresses you initially provided for withdrawal"
       mixer.distribute_for_withdrawal

     end
      # puts "addresses_for_withdrawal: #{user_addresses}"
      # puts "mixer_transactions: #{mixer.deposit_address_transactions}"
     # puts "The mixer is currently mixing!\n"
     # balance_in_from_address = get_address_balance(from_address)
     # balance_deposit_address = get_address_balance(new_address_for_deposit)
     # puts "Your new balance in #{from_address} is: #{balance_in_from_address}"
   else
     puts "Ah, well maybe next time"
   end
 else
   puts "Ah, well maybe some other time then."
 end
end

prompt
