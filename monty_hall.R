##
##################################
## Monty Hall problem simulator ##
##################################
#
# The Monty Hall problem is a famous brain teaser, perfectly designed to play with
# our assumptions around probabilities. It's loosely based on the American TV game show 
# "Let's Make a Deal", and named after its host, Monty Hall. The problem became famous 
# after featuring in Parade magazine in 1990, worded as follows:
#
# Suppose you're on a game show, and you're given the choice of
# three doors: Behind one door is a car; behind the others, goats.
# You pick a door, say No. 1, and the host, who knows what's behind 
# the doors, opens another door, say No. 3, which has a goat. He 
# then says to you, "Do you want to pick door No. 2?" Is it to your 
# advantage to switch your choice?
#
# This simulator lets you play as many trials of the game as you'd like and reports the
# results, to show that indeed the better strategy is to switch to the remaining door.
# It also lets you play around with the number of doors and chances to swap.
#


## Set up simulation
options(scipen = 999)

runs <- 1000 # number of simulation trials
doors <- 3 # number of doors (minimum and most famously 3)
chances <- doors - 2 # number of chances to switch doors

prize <- sample(1:doors, runs, replace = TRUE) # select the winning door for every trial
choice <- sample(1:doors, runs, replace = TRUE) # select the contestant's first choice of door for every trial

stay_wins <- 0 # initialise variable for number of wins when sticking to first choice
swap_wins <- 0 # initialise variable for number of wins when switching doors


## Run game simulation
for(i in 1:runs){
#staying strategy
  if(choice[i] == prize[i]){
    stay_wins <- stay_wins + 1
  }

#switching strategy
  options <- c(1:doors) # total set of doors
  remainder <- options[-c(prize[i], choice[i])] # subset of doors the host can reveal
  swap <- choice[i]
  for(sdt in 1:chances){
    revealdoor <- remainder[sample(length(remainder), 1)] # pick door to be revealed after a choice is made
    swap <- options[! options %in% c(revealdoor, swap)] # pick door to switch to
    swap <- swap[sample(length(swap), 1)]
    options <- options[! options %in% c(revealdoor)]
    remainder <- remainder[! remainder %in% c(revealdoor)]
  }
  if(swap == prize[i]){
    swap_wins <- swap_wins + 1
  }
}


## Display simulation results
print(paste0("Sticking to the original door choice won ", stay_wins, " out of ", runs," trials."))
print(paste0("Switching doors won ", swap_wins, " out of ", runs," trials."))


