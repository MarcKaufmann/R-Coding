# Lecture 4 Script
# First choose a new team for next week

library(readr)
dir <- Sys.getenv("R_CODING")
student_first_names <- read_csv(paste0(dir, "lecture2/student-names.csv"))
library(tidyverse)
sample_n(student_first_names, 4)

# What if we get the same students as before? How should we do this?

# Let's continue with chapter 5

##### mutate()

library(nycflights13)

# Let's stare at the columns to see what we can choose from
View(flights)

# Narrow the tibble to see what mutate() is doing
(flights_small <- select(flights,
                        year:day, 
                        ends_with("delay"), 
                        distance,
                        air_time))

mutate(flights_small, 
       catchup = dep_delay - arr_delay,
       speed_miles = (distance/air_time) * 60
       )

# No one knows what speed in miles is, let's fix that
# minutes_per_hour <- 60

# Magic numbers. Great, every one loves them. They are evil.
KM_PER_MILE <- 1.61

mutate(flights_small,
       speed_km = (distance * KM_PER_MILE/air_time) * 60)

# Even nicer is to create intermediate results for clarity
mutate(flights_small,
       distance_km = distance * KM_PER_MILE,
       air_time_hours = air_time / 60,
       speed_km = distance_km / air_time_hours
       )

# transmute only keeps new variables
transmute(flights_small,
       distance_km = distance * KM_PER_MILE,
       air_time_hours = air_time / 60,
       speed_km = distance_km / air_time_hours
       )

# You cannot use all transformations inside mutate.
# It has to be vectorized: it takes a vector and returns a vector of the same length
# The reason (I believe) is that the operation is done on the column as a whole,
# For this the operation needs to make sense for a whole column, not just for one number

# SOME VECTORIZED OPERATIONS

# Standard arithmetic functions will work: +, *, etc

# The time in dep_time is given by HHMM (How do I know this?)

transmute(flights,
          dep_time,
          dep_hour = dep_time %/% 100,
          dep_minutes = dep_time %% 100
          )

# log(), log2(), log10() work

# How can you test whether something is vectorized? 
(x <- c(0,1,2,3,4,5,6,7,8,9))
(y <- 0:9)
(z <- seq(0,9))

(lag(y))
(lag(lag(y)))
(lead(y))

# What do lag and lead do?

# Some cumulative and aggregate functions
cumsum(x)
cumprod(x)
cumprod(lead(x))
?cummin
?cummax
cummean(x)

# Logical operators work
x > 3
x > y
x == y
# What does the answer to this even mean?
x == c(2,4)
x > c(2,4,6)

# Ranking functions

y <- c(10, 5, 6, 3, 7)
min_rank(y)

# Can you figure out from playing around with min_rank() how it works exactly?

# So, what is not a vectorized operation?
c(2,4)^2 # This is vectorized
kk <- function(x) { x[3]}
kk(1:5) # not vectorized
mean(x)


# What happens when we try this on a dataframe
transmute(flights, delay = mean(arr_delay, na.rm = TRUE))
transmute(flights, delay = kk(arr_delay))

# Notice that it does not throw an error. 
# It does something that makes sense, if it is what you want.

## EXERCISES

# Exercise: Try out a few of the other commands in the chapter.
# Exercise: Create several ranges with the n:m notation, i.e. 2:4, 4:8, etc.
#           Try to find out whether you can also take negative ranges and descending
# Exercise: Read ?":" (the same as help(":"))
# Exercise: Use slice() to choose the first 10 rows of flights. 
# Do the following exercises from 5.5.2:
# Exercise 1
# Exercise 2
# Exercise 4
# Hint: When you get stuck, try the following two strategies:
# 1. Take a single row, and work it out by hand
# 2. Create a variable my_flights which contains only a few rows (4 to 10).
#     Work out a solution for my_flights, where you can check every step.

### summarise()

summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

# How... useful. Might as well do
mean(flights$dep_delay, na.rm = TRUE)
# <data-frame>$<column-name> will give you that column. Quick way to choose columns.
mean(select(flights, dep_delay), na.rm = TRUE)

# An error I made: I tried this:
# Huh? What's going on here? 
flights$dep_delay
select(flights, dep_delay)
# I thought select(flights, dep_delay) was the same as flights$dep_delay
# Aha, we should have guessed, since select returns a *data frame*,
# but we want a column. A data frame of 1 column is not the same as 
# a single column.

# Still, summarise is way more interesting with its friend, group_by

by_day <- group_by(flights, year, month, day)
by_day

# Looks distinctly the same

# But it really isn't!
summarise(
  group_by(flights, year, month, day), 
  delay = mean(dep_delay, na.rm = TRUE)
  )

# 5.6.1
# Let's explore link between distance and average delay for every location
# What that means is that we want to know the average delay for every destination.
# Then, once we have that, we want to see how the distance to this location
# is related to the delay to this location.

by_destination <- group_by(flights, dest)
delay <- summarise(by_destination,
                   delay = mean(arr_delay, na.rm = TRUE))
delay

# OK, we need the distance too, or else there is not much to plot.
(delay <- summarise(by_destination,
                   delay = mean(arr_delay, na.rm = TRUE),
                   distance = mean(distance, na.rm = TRUE)))

p <- ggplot(data = delay,
            mapping = aes(x = distance, y = delay))
p + geom_point() + geom_smooth()

(delay <- summarise(by_destination,
                    count = n(), 
                   delay = mean(arr_delay, na.rm = TRUE),
                   distance = mean(distance, na.rm = TRUE)))

p <- ggplot(data = delay,
            mapping = aes(x = distance, y = delay))
p + geom_point(mapping = aes(size = count), alpha = 0.2) +
  geom_smooth()


# n() is a very special function
#n()

# Finally...


# Optional exercise as part of assignment 5 (somewhat harder): The above does not take into account 
# the number of flights per location. A location with 1 flight matters as much
# for smoothing as a location with 300. 
# That is rarely what we want when smoothing globally. Read the following code,
# to see if you understand how it works. Explain in your words in the .Rmd file.

# Let's plot the original data, without first taking means by group
# Woah, that looks different! (And ugly.)

# So, not too misleading, but still...
# END OF EXERCISE

# Doing this with a pipe, and filtering out destinations with 
# - less than 20 flights
# - to HNL (Honululu), since it's by far the furthest
# Note: I am not a big fan of dropping things that 'look too different'.
# You should do such robustness checks, but you shouldn't start there. 

delays <- flights %>% 
  group_by(dest) %>%
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    count = n(),
    distance = mean(distance, na.rm = TRUE)
    ) %>%
  filter( count > 20, dest != "HNL")

# Exercise: Rewrite the above command without the pipe. Which one do you find 
# easier to read?

# 5.6.2 Missing values

not_missing <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))

# Exercise: Does the above command also drop observations that miss only the arr_delay
# but have a dep_delay? Are there any observations in the dataset for which
# only dep_delay or arr_delay is missing, but not both?


## 5.6.3 Counts

## Average delay by airplane (identified by tailnum), plot density
## Start with freqpoly, then zoom in on that part of the graph that we are interested
not_missing %>%
  group_by(tailnum) %>%
  summarise(delay = mean(dep_delay)) %>%
  ggplot(mapping = aes(x = delay)) + 
  geom_histogram(binwidth = 10)


## Plot number of flights per airplane against delay

not_missing %>%
  group_by(tailnum) %>%
  summarise(
    count = n(),
    delay = mean(arr_delay)
    ) %>%
  ggplot(mapping = aes(x = delay, y = count)) + 
  geom_point(alpha = 0.1)
         
## Since I need to filter the same thing, all the time 
# just store in a variable. Delete other stuff.
not_missing_planes <- not_missing %>%
  group_by(tailnum) %>%
  summarise(
    count = n(),
    delay = mean(arr_delay),
    delay_median = median(arr_delay)
    )
  

# Get the median delay for each ariplane
ggplot(data = not_missing_planes) + 
  geom_histogram(mapping = aes(x = delay_median)) + 
  geom_histogram(mapping = aes(x = delay), color = 'yellow', alpha = 0.3)
  

not_missing_planes %>%
  filter(count > 5) %>%
  ggplot(mapping = aes(x = delay)) + 
  geom_histogram()

# Filter the airplanes that fly rarely and pipe them into 
# ggplot which gets plussed into geoms
# Try a few values for how many flights one should have done

# Assignment 5: 

# 1. Do the exercises in this script file and work through the examples we 
# didn't cover in class. As usual, turn the script into an .Rmd file, knit it,
# upload the .html and .pdf.

# 2. Read/skim the chapter 5 from 'R for Data Science' to see what is available.
# Don't try to remember everything, but you should be able to remember what is 
# possible so that you can find the commands again should you need them in the 
# future. 

# 3. Grade Assignment 4 of your peers.

# 4. Document at least 10 errors and warnings you actually hit during the week. 
# If you do *not* hit that many errors or receive such warnings, congratulations.

# 5. Pick one of the hotels graphs in Chapter 3, section 6, A1. Case study, finding a 
# good deal among hotels. Replicate it -- try it yourself for 10 minutes before you go
# looking at the code -- and then make a variation of it.

# 6. Instead of using the Vienna data, use the data for another city 
# (pick London if you don't want to choose). Do a basic data exploration,
# comparing the city to Vienna in terms of any variables you find interesting.
# Three plots maximum, don't spend more than 30 minutes on the analysis, before
# writing it down (if you are not doing this in parallel).
