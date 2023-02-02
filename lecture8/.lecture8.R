# Lecture 8: Chapter 13 in R4DS

library(tidyverse)
library(nycflights13)

# Joins
planes

# tailnum is a primary key
planes %>%
  count(tailnum) %>%
  filter(n > 1)

# What is a pkey for flights? Flight by day
flights %>%
  count(year, month, day, flight) %>%
  filter(n > 1)

# Add a primary key
(flights2 <- flights %>%
  mutate(pkey = row_number()) %>%
  select(pkey, everything()))
  
## Mutating Joins

flights2
colnames(airlines)
colnames(flights2)

flights2 <- flights2 %>%
  select(year:day, hour, origin, dest, carrier, tailnum)

flights2 %>% slice(2)
flights2 %>%
  left_join(airlines, by = "carrier") %>%
  slice(n=2)

# Strong recommendation
# Do work through 13.4.1 and following in R4DS

x <- tibble("name" = c("m", "lm", "wm"),
            "height" = c(1.19, 1.80, 0.00))
y <- tibble(
  name = c("m", "m", "lm", "bm"),
  class = c("R", "I", "LR", "NC")
)
x
y

left_join(x,y)
right_join(y,x)
right_join(x,y)
inner_join(x,y)
full_join(x,y)

flights2 %>%
  left_join(weather)

flights2 %>%
  left_join(weather, by = c("year", "month", "day",
                            "hour",
                            "origin"))
flights2 %>%
  left_join(weather, by = c("year", "month", "day",
                            "hour",
                            "dest" = "origin"))
unique(weather$origin)

# 13.5 Filtering Join

# Find the top 10 most popular destinations

(top10 <- flights %>%
    count(dest) %>%
    filter(rank(desc(n)) < 11) %>%
    arrange(desc(n)))

# Get only the flights to the top destinations
flights %>%
  filter(dest %in% top10$dest)

flights %>%
  semi_join(top10)

# Get the top 11 dest
(ranked_dest <- flights %>%
    count(dest) %>%
    mutate(r = rank(desc(n))) %>%
    arrange(r))

flights %>%
  semi_join(ranked_dest %>% filter(r <= 11))

flights %>%
  filter(dest %in% ranked_dest$dest[1:11])

# With multiple fields you really want semi-join

(worst_days <- flights %>%
    group_by(year, month, day) %>%
    summarise(delay = mean(arr_delay, na.rm = TRUE)) %>%
    ungroup() %>%
    mutate(rank_delay = rank(desc(delay))) %>%
    arrange(rank_delay))
    )

flights %>%
  inner_join(worst_days %>% filter(rank_delay <= 10))

flights %>%
  anti_join(planes, by = "tailnum")

# Three steps to make sure the joing works:
# 1. What is the primary key?
# 2. Is the primary key present for all rows?
# 3. Does the pkey exist in both tables, does every 
# observation match? anti_join()

# Look at setdiff(), intersect(), union()

# Chapter 23? Models?

library(modelr)
library(ggplot2)
sim1

ggplot(sim1, aes(x,y)) + 
  geom_point()

# Create a lot of random linear models
# y = a1 + a2 * x
(models <- tibble(
  a1 = runif(250, -20, 40), 
  a2 = runif(250, -5, 5)
))

ggplot(sim1, aes(x,y)) + 
  geom_abline(data = models, 
              aes(intercept = a1, slope = a2),
              alpha = 1/4) + 
  geom_point()

model1 <- function(a, data) {
  a[1] + data$x * a[2]
}

model1(c(7,1.5), sim1)

# MSE:Mean-squared error
measure_distance <- function(mod, data) {
  diff <- data$y - model1(mod, data)
  sqrt(mean(diff^2))
}

sim1_dist <- function(a1, a2) {
  measure_distance(c(a1, a2), sim1)
}

models <- models %>%
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))

models

# Get the top models
(top_models <- models %>%
    filter(rank(dist) <= 10))

ggplot(sim1, aes(x,y)) + 
  geom_point() + 
  geom_abline(data = top_models, 
              aes(intercept = a1, slope = a2, color = -dist))

ggplot(models, aes(a1, a2, color = -dist)) + 
  geom_point(data = filter(models, rank(dist) <= 10), 
             size = 4, 
             color = 'red') + 
  geom_point()

best <- optim(c(0,0), measure_distance, data = sim1)
best$par

sim1_mod <- lm(y ~ x, data = sim1)
sim1_mod

ggplot(sim1, aes(x,y)) + 
  geom_point() + 
  geom_abline(intercept = best$par[1], 
              slope = best$par[2])


# Assignment

# Exercise 1. Merge the two Europe datasets into one. Which hotels do not have 
# matches in the price data? Use anti_join.
#
# Exercise 2. Come up with 3 models to explore what drives the price of 
# hotels in Vienna (later you'll do it for another city too). Plot the price of hotels against some of the main variables
# that seem to have the most explanatory power.

# Exercise 3. Look at the residuals from your favorite model. Now plot these 
# against 3 variables that you didn't include earlier - or if you included all
# plot them agains some variables in a form that you did not do before 
# (squares, logs, interactions). Do the residuals look random? 

# Exercise 4. Try to find out some methods to check if residuals are random and 
# how to code this in R. Find at least two ways.

# Exercise 5. Use your model estimated on Vienna to predict prices for another city.
# How well does your model do, if you use the parameter values estimated on Vienna?
# Example: In part 3 you will have run some model similar to 
# vienna_model <- lm(y ~ x, data = my_vienna_data)
# or some such. Use the vienna_model, with the parameters estimated on the Vienna dataset
# to see how well it does (and what it predicts) for some other city.
# the notes on lecture8-pre-class.R contain code that computes predictions. 
# You pick how you measure 'how well it does'.

# Exercise 6. Reestimate your favorite model (the same as from exercise 1) for
# another city. How much do the parameter values change? How well does the model
# do now? If you had to summarise the difference between the 2 cities in one 
# number based on your model, what would it be?
# Example: In this exercise, you should run the same formula as in exercise 3, but
# run it on the data for another city (the same one as in exercise 5).
# Thus if you ran lm(y ~ x, data = my_vienna_data), you now run lm(y ~ x, data = my_other_city_data)

