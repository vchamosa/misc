################################
#                              #
#    WORK ABROAD CALCULATOR    #
#                              #
################################
# Victor Chamosa Pino
#

### Set up environment ###
# load in libraries
library(lubridate)
library(anytime)
library(plyr)
library(dplyr)
library(tictoc)

# set path
input_path <- "C:/Users/victorc.pino/OneDrive - Energy Saving Trust/Documents"


### Init ###
# set values
maxd <- 60
lastyear <- interval((today() - years(1)), today())

# get inputs
dabroad <- read.csv(paste0(input_path,"/days_abroad.csv"), colClasses = c("Date"))
bankhol <- read.csv(paste0(input_path,"/scot_bank_holidays_2025-26.csv"), colClasses = c("Date"))


### Calculate ###
tic()
for(i in 1:nrow(dabroad)){
  time_abroad <- interval(dabroad$start[i], dabroad$end[i])
  if(time_abroad %within% lastyear){
    # workdays <- int_length(time_abroad)/(60*60*24)
    # print(workdays)
    # workdays <- time_abroad/ddays(1)
    # print(workdays)
    workdays <- time_abroad/days(1)
    print(workdays)
  } else if(int_overlaps(time_abroad, lastyear)){
    print("overlap")
  }
}
toc()

tic()
workabroad <- dabroad %>%
  mutate(interval_abroad = interval(dabroad$start, dabroad$end)
         )
workabroad <- workabroad %>%
  mutate(no_days = interval_abroad/days(1)
         )
toc()

