require_relative 'utils'

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
   # JobCoinMixer.new(new_address_for_deposit, addresses_for_withdrawal).listen
   puts "Please enter the address from which you will be depositing your jobcoin:"

   from_address = gets.strip
   from_address_balance = get_address_balance(from_address)

   puts "The current balance at #{from_address} is: #{from_address_balance}.
    How much do you want to deposit?"

  deposit_amount = gets.strip

  puts "Are you sure you want to deposit #{deposit_amount} into #{new_address_for_deposit}? (y/n)"
   go_deposit = gets.strip
   if go_deposit == "y"
     transfer_funds(from_address, new_address_for_deposit, deposit_amount)
     balance_in_from_address = get_address_balance(from_address)
     balance_deposit_address = get_address_balance(new_address_for_deposit)
     puts "Your new balance in #{from_address} is: #{balance_in_from_address}"
     puts "The balance in #{new_address_for_deposit}: #{balance_deposit_address}"

   else
     puts "Ah, well maybe next time"
   end
 else
   puts "Ah, well maybe some other time then."
 end
end
