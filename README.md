# Jobcoin Mixer

### Intention
A small program that looks to mimic the basic flow of a coin mixer.

### Running the program

This program is written in ruby. In order to run it, please follow these instructions:

- please clone/download/fork the repo
- then run `bundle install` inside the root of the repo. This will install all the dependencies for the project
- in order to start the program, execute the following in the root of this project:
`ruby index.rb`

If all is well you should see the following greeting:
`Welcome to the Jobcoin Mixer!`

You can of course make your own address for deposit, but can use the address `NoesAddress1` as well. It currently has around 25 jobcoins still left in the account

Do be completely honest: I recommend simple inputs for the first test run. Only put one address for pick up, only do one deposit, etc, in order to see the program run to completion, and then have fun. Some scenarios may not work, but so it goes. If the program hangs for whatever reason, just exit and restart :).


### Implementation
I thoroughly enjoyed thinking through this challenge, and though my approach is not too involved, I can definitely see how intricate a system dedicated to 'mixing' and maintaining anonymity could become.

Some comments on my approach:
- I tried to keep things simple and linear. I did not employ a means for polling in the background, or set off any background workers to complete any tasks. I also did not use a database, instead initiating a new mixer everytime the program is started up.
- The goal for me was not to make a real coin mixer, so much as to demonstrate my understanding of the problem.

### Further Work (TODO)
- I have some tests, but would like to add to them. The `JobcoinMixer` could do with some more scenarios, and the `index.rb` file could use some as well.
- The `index.rb` file is a little difficult to read. I would love to map out some more user flows, and make that code more extendable. The current implementation is not too robust, and taking some more time there would be nice.
- Actually poll the whole P2P network. The api to gather all transactions was available, but I did not use it in this approach to the problem. With more time, I would love to make use of this endpoint.
