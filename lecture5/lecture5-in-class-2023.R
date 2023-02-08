# Last time: mutate, transmute, NA

# filter(flights, tailnum != "joao")
# This checks for equality on the string "NA"
# filter(flights, tailnum != "NA")
# The next checks for NA values
# filter(flights, tailnum != NA)
# filter(flights, tailnum == NA)
# filter(flights, tailnum == "NA")

library(tidyverse)
library(nycflights13)
View(flights)
unique(is.na(flights[["tailnum"]]))
(flights_small <- flights |> 
    select(
      year:day,
      ends_with("delay"),
      distance,
      air_time
    ))

KM_PER_MILE <- 1.61
flights_small |>
  mutate(
    distance_km = distance * KM_PER_MILE,
    air_time_hours = air_time / 60,
    speed_km = distance_km / air_time_hours
  )

# Vectorized Operations: the operation takes a vector and returns a vector
# of the same length

# What are some common vectorized operations
(x <- c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9))
(y <- 0:9)
(z <- seq(0, 9))
(w <- seq(0, 10, by=2))

(lag(y))
(lag(lag(y)))
(lead(y))

# Some cumulative and aggregate functions
cumsum(x)
cumprod(x)
?cummin
?cummax
cummean(x)

# Logical operators are vectorized
x > 3 # Without recycling, this would need to be x > rep(0, length(x), 3)
x > y
x == y
x & y # Don't do this (too much)
x == c(2, 4)
# R recycles vectors to get vectors of matching length
# Next is c(F, F, F, T), because this is c(1, 2, 3, 4) == c(2, 4, 2, 4)
c(1, 2, 3, 4) == c(2, 4) 
# Next is c(F, T), because the 4 gets recycled twice: c(4, 4) == c(2, 4)
4 == c(2, 4)
c(2, 4) == c(1, 2, 3) # equal to  c(2, 4, 2) == c(1, 2, 3)

c(4, NA) == c(4, 4, 4, 4)

# Ranking functions
y <- c(10, 5, 5, 3, 7)
min_rank(y)
typeof(min_rank(y))
?min_rank
rank(y)
typeof(rank(y))

# What is not vectorized?
c(2, 4)^2
third <- function(x) { x[3] }
third_fourth <- function(x) { x[3:4] }
third(c(2, 4, 6))
mean(x)

transmute(flights, delay = mean(arr_delay, na.rm = TRUE))
transmute(flights, delay = third(arr_delay))
transmute(flights, delay = third_fourth(arr_delay))
transmute(flights, delay = list(a = 3))
transmute(flights, delay = list(a = 3, b = "bla"))
str(list(a = 3))
typeof(list(a = 3))

# Notice those returning a single element don't throw errors, which is maybe 
# what you want (if you expect a constant) or not.

## summarise()

summarise(flights, delay = mean(dep_delay - arr_delay, na.rm = TRUE))
# Easier
mean(flights[["dep_delay"]], na.rm = TRUE)

(by_day <- group_by(flights, year, month, day))

summarise(
  by_day,
  delay = mean(dep_delay, na.rm = TRUE)
)
# Plot the relationship between distance of flight and average delay by destination. 
# To plot, first compute the average delay for each destination.
(distance_delay <- flights |>
    group_by(dest) |> 
    summarise(
      avg_delay = mean(arr_delay, na.rm = TRUE),
      distance = mean(distance, na.rm = TRUE),
      N = n()
    )) 

ggplot(
  data = distance_delay, 
  mapping = aes(x = distance, y = avg_delay, size = N)
) + 
  geom_point(alpha = 0.3) +
  geom_smooth() +
  geom_smooth(aes(weight = N), color = "yellow")

flights |> 
  group_by(dest, distance)  |> 
  summarise(N = n()) 

# Start: Practice functions

# Last 20 minutes practice:
# - functions
# - ggplot
# - select, filter, arrange, mutate

