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
# It also lets you play around with the number of doors, though only one switch will be
# permitted per trial.
#


## Set up simulation
options(scipen = 999)

runs <- 100000 # number of simulation trials
doors <- 3 # number of doors (minimum and most famously 3)

prize <- sample(1:doors, runs, replace = TRUE) # select the winning door for every trial
firstchoice <- sample(1:doors, runs, replace = TRUE) # select the contestant's first choice of door for every trial

revealdoor <- rep(0,runs) # initialise variable for door to be revealed after first choice made
swap <- rep(0,runs) # initialise variable for door to swap to

stay_wins <- 0 # initialise variable for number of wins when sticking to first choice
swap_wins <- 0 # initialise variable for number of wins when switching doors


## Run game simulation
for(i in 1:runs){
#staying strategy
  if(firstchoice[i] == prize[i]){
    stay_wins <- stay_wins + 1
  }

#switching strategy
  remainder <- c(1:doors)[-c(prize[i], firstchoice[i])]
  revealdoor <- remainder[sample(length(remainder), 1)]
  swap <- c(1:doors)[-c(revealdoor, firstchoice[i])]
  swap <- swap[sample(length(swap), 1)]
  if(swap == prize[i]){
    swap_wins <- swap_wins + 1
  }
}


## Display simulation results
print(paste0("Sticking to the original door choice won ", stay_wins, " out of ", runs," trials."))
print(paste0("Switching to the other door won ", swap_wins, " out of ", runs," trials."))


