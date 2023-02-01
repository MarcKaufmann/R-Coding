# Lecture 4 Script

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
       speed_miles = (distance/air_time) * 60)

# No one knows what speed in miles is, let's fix that
# minutes_per_hour <- 60

mutate(flights_small,
       speed_km = (distance * 1.61/air_time) * 60)

# Magic numbers. Great, every one loves them. They are evil.
KM_PER_MILE <- 1.61

mutate(flights_small,
       speed_km = (distance * KM_PER_MILE/air_time) * 60)

# Even nicer is to create intermediate results for clarity
mutate(flights_small,
       distance_km = distance * KM_PER_MILE,
       air_time_hours = air_time / 60,
       speed_km = distance_km / air_time_hours)

# transmute only keeps new variables
transmute(flights_small,
       distance_km = distance * KM_PER_MILE,
       air_time_hours = air_time / 60,
       speed_km = distance_km / air_time_hours)

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
          dep_minutes = dep_time %% 100)

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
min_rank(c(y, 7))
rank(c(y, 7))

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
flights_delay <- summarise(
  by_destination,
  avg_arr_delay = mean(arr_delay, na.rm = TRUE)
)
flights_delay

# OK, we need the distance too, or else there is not much to plot.
(flights_delay <- summarise(
  by_destination,
  avg_arr_delay = mean(arr_delay, na.rm = TRUE),
  distance = mean(distance, na.rm = TRUE) # Somewhat of a hack
))

p <- ggplot(data = flights_delay,
            mapping = aes(x = distance, y = avg_arr_delay))
p + geom_point() + geom_smooth()

(flights_delay <- summarise(by_destination,
                    count = n(), 
                    avg_arr_delay = mean(arr_delay, na.rm = TRUE),
                    distance = mean(distance, na.rm = TRUE)))

p <- ggplot(data = flights_delay,
            mapping = aes(x = distance, y = avg_arr_delay))
p + geom_point(mapping = aes(size = count), alpha = 0.2) +
  geom_smooth()


# n() is a very special function
#n()

# Finally...

# Optional exercise as part of assignment 2 (somewhat harder): The above smoothing does not take into account 
# the number of flights per location - we only plot points by weight. A location with 1 flight matters as much
# for smoothing as a location with 300. 
# That is rarely what we want when smoothing globally. Read the following code,
# to see if you understand how it works. Explain in your words in the .Rmd file.

# Let's plot the original data, without first taking means by group
# Woah, that looks different! (And ugly.)
p2 <- ggplot(data = flights,
             mapping = aes(x = distance, y = arr_delay))
p2 + geom_point(alpha = 0.2) + geom_smooth()

# Now let's plot points by location as before, but run geom_smooth on whole dataset
p2 + geom_point(data = flights_delay, aes(y = avg_arr_delay, size = count), alpha = 0.3) +
  geom_smooth()
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
    avg_arr_delay = mean(arr_delay, na.rm = TRUE),
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
  summarise(avg_delay = mean(dep_delay)) %>%
  ggplot(mapping = aes(x = delay)) + 
  geom_histogram(binwidth = 10)


## Plot number of flights per airplane against delay

not_missing %>%
  group_by(tailnum) %>%
  summarise(
    count = n(),
    avg_delay = mean(arr_delay)
    ) %>%
  ggplot(mapping = aes(x = avg_delay, y = count)) + 
  geom_point(alpha = 0.1)
         
## Since I need to filter the same thing, all the time 
# just store in a variable. Delete other stuff.
not_missing_planes <- not_missing %>%
  group_by(tailnum) %>%
  summarise(
    count = n(),
    avg_delay = mean(arr_delay),
    delay_median = median(arr_delay)
    )
  

# Get the median delay for each airplane
ggplot(data = not_missing_planes) + 
  geom_histogram(mapping = aes(x = delay_median)) + 
  geom_histogram(mapping = aes(x = avg_delay), color = 'yellow', alpha = 0.3)
  
# Filter the airplanes that fly rarely and pipe them into 
# ggplot which gets plussed into geoms
# Try a few values for how many flights one should have done

not_missing_planes %>%
  filter(count > 5) %>%
  ggplot(mapping = aes(x = avg_delay)) + 
  geom_histogram()

# ## Assignment 2
# 
# 1. Read/Skim Chapter 5 of Grolemund and Wickham parts 1 through 4 (including select) of Grolemund and Wickham for anything we did not cover. We will cover the remaining parts next week.
# 2. Do all the exercises from this week in lecture3-script.R and lecture4-script.R. Put them (with title/statement of exercise) 
#    in a single .Rmd, and solutions in code chunks. 
# 3. Repeat the steps from chapter 5 in parts 1 through 3, but using hotels data instead of the nycflights data. You
#    can load the data as follows (assuming you run this script from within the folder lecture3/:
hotels_vienna <- read_csv("../da_data_repo/hotels-vienna/clean/hotels-vienna.csv")
# Since the two datasets don't have the same columns, either pick some variable you'd like to filter on and see results on, or use the following suggested mapping:
# Repeat every step for which Grolemund and Wickham show the output - thus ignore all the exercises, or options they mention without.
#   - When filtering (etc) on month for flights, use stars in the hotels data
#   - Instead of flight duration, use hotel price
#   - For travel times, use distance (you can reuse distance for different types of time)
# 
# Example: Instead of doing
# filter(flights, month == 1)
# you should do
# filter(hotels, stars == <some-number-you-like>)
# Create similar output to Grolemund and Wickham, i.e. show what the output is of various commands.
# 
# 4. Read/skim the chapter 5 from 'R for Data Science' to see what is available.
# Don't try to remember everything, but you should be able to remember what is 
# possible so that you can find the commands again should you need them in the 
# future. 

# 5. Grade Assignment 1 of your peers.

# 6. Document 4 errors and warnings you actually hit during the week. 
# If you do *not* hit that many errors or receive such warnings, congratulations.

# Put all the parts requiring text or code into a single .Rmd file, knit it to a pdf file, and upload the pdf to the submission server.