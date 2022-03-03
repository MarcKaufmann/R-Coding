# Lecture 4 in class script

## Assignments:
# 0. Always git: fetch updates (in your repo), then `git pull` to your machine
# 1. Assignments:
#    - Submit an empty pdf if you cannot submit anything (unless I implement something clever)
#      That way you can review others and receive those points
#    - Do not name your assignment after you, and do not include your name
# 2. Given the 115 points, I don't expect 100% on all assignments 
#    -- learn time management
# 3. Slack: 
#    - use 'reply in thread' when appropriate (usually, unless new topic)
#    - #oh-shit-knit: new channel for issues with knitting. Post your issues and solutions
#      for current and future students
# 4. Two different data sets with ggplot

#### mutate()

library(tidyverse)
library(nycflights13)

View(flights)

# Narrow the tibble for ease of use and see what mutate does
(flights_small <- select(flights,
                         year:day,
                         ends_with("delay"),
                         distance,
                         air_time))

mutate(
  flights_small, 
  catchup = dep_delay - arr_delay,
  speed_in_miles = (distance/air_time) * 60
)

# Get the speed in km/hour
mutate(
  flights_small, 
  speed_in_km = (distance * 1.61 / air_time) * 60
)

# 1.61 is a MAGIC NUMBER - they are not good, create a variable with that value
KM_PER_MILE <- 1.61
mutate(
  flights_small,
  speed_in_km = (distance * KM_PER_MILE / air_time) * 60 # 60 is a magic number
)

# If there are many steps, instead of computing all at once, create intermediate values
mutate(
  flights_small,
  distance_km = distance * KM_PER_MILE,
  air_time_hours = air_time / 60,
  speed_in_km = distance_km / air_time_hours
)

transmute(
  flights_small,
  distance_km = distance * KM_PER_MILE,
  air_time_hours = air_time / 60,
  speed_in_km = distance_km / air_time_hours
)
  
# Inside mutate you can only use *vectorized* operations:
# one that takes a vector and returns a vector of the same length

transmute(
  flights,
  dep_time,
  dep_hour = dep_time %/% 100,
  dep_minutes = dep_time %% 100
)

# log(), log2(), log10() are vectorized
(x <- seq(0, 10))
(y <- 0:10)

(lag(y))
(lag(lag(y)))
(lead(y))

# Some cumulative and aggregate functions
cumsum(x)
cumprod(x)
cumprod(lead(x))
?cummin
?cummax
cummean(x)

# Logical operators
x > 3
x > y
x == y
x == c(2,4)
(length(x) == length(c(2,4)) && all(x == c(2,4)))
x > c(2, 4, 6)

# Ranking functions
y <- c(10, 5, 6, 3, 7)
min_rank(y)

# What is not vectorized?
kk <- function(x) { x[3] }
# These return a single number when given a vector
kk(1:5)
mean(x)

transmute(
  flights,
  delay = mean(arr_delay, na.rm = TRUE)
)
transmute(
  flights,
  delay = kk(arr_delay)
)

# Note to self: try &&

### summarise() or summarize()

summarise(flights, delay = mean(dep_delay, na.rm = TRUE))
?mean

# Easier: <data-frame>$<column-name> extracts that column as a vector
mean(flights$dep_delay, na.rm = TRUE)

select(flights, dep_delay)

summarise(
  flights, 
  dep_delay = mean(dep_delay, na.rm = TRUE),
  arr_delay = mean(arr_delay, na.rm = TRUE)
)
  
by_day <- group_by(flights, year, month, day)
by_day
flights

summarise(
  by_day,
  delay = mean(dep_delay, na.rm = TRUE)
)

# Link between distance and average delay

by_destination <- group_by(flights, dest)
flights_delay <- summarise(
  by_destination, 
  avg_arr_delay = mean(arr_delay, na.rm = TRUE)
)
flights_delay

(flights_delay <- summarise(
  by_destination,
  avg_arr_delay = mean(arr_delay, na.rm = TRUE),
  distance = mean(distance, na.rm = TRUE)
))

p <- ggplot(data = flights_delay,
            mapping = aes(x = distance, y = avg_arr_delay))
p + geom_point() + geom_smooth()

(flights_delay <- summarise(
  by_destination,
  count = n(),
  avg_arr_delay = mean(arr_delay, na.rm = TRUE),
  distance = mean(distance, na.rm = TRUE)
))

p <- ggplot(data = flights_delay,
            mapping = aes(x = distance, 
                          y = avg_arr_delay))

p + geom_point(mapping = aes(size = count), alpha = 0.2) + geom_smooth()

p2 <- ggplot(data = flights,
             mapping = aes(x = distance,
                           y = arr_delay))
p2 + geom_point(data = flights_delay, 
                mapping = aes(x = distance,
                              y = avg_arr_delay,
                              size = count),
                alpha = 0.3) + 
  geom_smooth()

p + geom_point(mapping = aes(size = count), alpha = 0.3) +
  geom_smooth(color = "red") + 
  geom_smooth(mapping = aes(weight = count)) + 
  geom_smooth(data = flights,
              mapping = aes(y = arr_delay),
              color = "yellow")
