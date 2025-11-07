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
library(dplyr)
library(purrr)

# set path
input_path <- "C:/Users/victorc.pino/OneDrive - Energy Saving Trust/Documents"


### Init ###
# set values
maxd <- 60
lastyear <- interval((today() - years(1)), today())

# get inputs
dabroad <- read.csv(paste0(input_path,"/days_abroad.csv"), colClasses = c("Date"))
bankhol <- read.csv(paste0(input_path,"/scot_bank_holidays_2025.csv"), colClasses = c("Date"))


### Calculate ###
dabroad <- dabroad %>%
  mutate(workdays = map2_int(start, end, ~ {
          days <- seq(.x, .y, by = "day")
          sum(!wday(days) %in% c(1, 7) & !(days %in% bankhol) & (days %within% lastyear))
        }))
days_left <- maxd - sum(dabroad$workdays)
print(days_left)


