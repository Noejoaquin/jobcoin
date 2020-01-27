require_relative 'utils'

puts "Welcome to the jobcoin mixer!"
puts "Please enter a comma-separated list of new, unused Jobcoin addresses
where your mixed Jobcoins will be sent:"

addresses = gets.strip

new_address_for_deposit = generate_deposit_address

puts "You may now send Jobcoins to this new deposit address: #{new_address_for_deposit}.
 If you choose, they will be mixed and sent to this destination. \n
 Would you like to mix and send?(Enter 'y' for 'yes', or 'n' for 'no')"

mix_and_send = gets.strip

 if mix_and_send == 'y' || mix_and_send == 'yes'
   puts "Alrighty, lets get mixing!"
 else
   puts "Ah, well maybe some other time then."
 end
