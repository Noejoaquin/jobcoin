require_relative 'utils'
require_relative 'jobcoin_client'
require_relative 'jobcoin_mixer'
require 'colorize'

def prompt(mixer = nil)
  puts "Welcome to the Jobcoin Mixer!".blue
  puts "Please enter a comma-separated list of new, unused Jobcoin addresses
where your mixed Jobcoins will be sent for withdrawal (ex. someAddress1,someAddress2):"

  addresses_for_withdrawal = gets.strip
  new_address_for_deposit = generate_deposit_address

  puts "You may now send Jobcoins to this new deposit address:"
  puts "#{new_address_for_deposit}".green
  puts "If you choose, they will be sent to this destination.
Would you like to deposit for future withdrawal?(y/n)"

  deposit = gets.strip

 if deposit == 'y' || deposit == 'yes'
   puts "Please enter the address from which you will be depositing your jobcoin (ex. NoesAddress1):"

   from_address = gets.strip
   from_address_balance = JobcoinClient.get_address_balance(from_address)

   puts "The current balance at #{from_address} is: #{from_address_balance}.
How much do you want to deposit?(ex. 3)"

  deposit_amount = gets.strip

  puts "Are you sure you want to deposit #{deposit_amount} Jobcoin(s) into #{new_address_for_deposit}? (y/n)".red
   go_deposit = gets.strip

   if go_deposit == "y"
     JobcoinClient.transfer_funds(from: from_address, to: new_address_for_deposit, amt: deposit_amount)
     last_trans = JobcoinClient.last_transaction_for(from_address) #returns hash
     timestamp = last_trans["timestamp"]
     user_addresses = addresses_for_withdrawal.split(",")
     mixer = JobcoinMixer.new unless mixer
     data_for_mixer = {
       user_address: from_address,
       withdrawal_addresses: user_addresses,
       timestamp: timestamp,
       total_amt: deposit_amount
     }
     mixer.add_transaction(new_address_for_deposit, data_for_mixer)
     puts "Your transaction has been made. Our mixer will now poll, and transfer your coins".blue
     mixer.poll

     puts "your coins have made it to the house account!"
     puts "current balance of the house account:"
     puts "#{JobcoinClient.get_address_balance(JobcoinMixer::HOUSE_ADDRESS)}".green

     puts "Are there any more deposits you would like to make? (y/n)"
     more_deposits = gets.strip
     if more_deposits == "y"
       prompt(mixer)
     else
       puts "Okay, since there are no other deposits you would like to make, we will now distribute your
funds to the addresses you initially provided for withdrawal...\n"
       mixer.distribute_for_withdrawal
       mixer.display_receipts
       exit
     end
   else
     puts "Ah, well maybe next time"
   end
 else
   puts "Ah, well maybe some other time then."
 end
end

def exit
  puts "Thanks for mixing with us! Until next time!"
end

prompt
