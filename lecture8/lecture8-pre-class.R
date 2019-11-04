# Lecture 8

library(tidyverse)
library(nycflights13)

planes
# Tailnum is a primary key
planes %>%
  count(tailnum) %>%
  filter(n > 1)

# Is flight number a primary key for a flight by day?
flights %>%
  count(year, month, day, flight) %>%
  filter(n > 1)

# Add a primary key
flights <- flights %>% 
  mutate(pkey = row_number()) %>%
  select(pkey, everything())

## Mutating Joins

flights
airlines
# Reduce number of cols to see what changes with joins
flights2 <- flights %>%
  select(year:day, hour, origin, dest, carrier, tailnum)

flights2 %>%
  left_join(airlines, by = "carrier")

# Strong recommendation:
# Work through sections 13.4.1 and following to understand joins

x <- tibble("name" = c("marc", "little marc", "where is marc?"), "height" = c(1.91, 1.80, 0.00))
y <- tibble(
  name = c("marc", "marc", "little marc", "big marc"),
  class = c("R Coding", "Information Economics", "Little R", "No class")
  )

left_join(x, y)
right_join(x,y)
left_join(y, x)
inner_join(x,y)
full_join(x,y)

# Get weather for NY airports
flights2 %>%
  left_join(weather)

# Get weather for destination airports
flights2 %>%
  left_join(weather, by = c("year", "month", "day", "hour", "dest" = "origin"))

# Why did that not work? Because we only have the following airports:
unique(weather$origin)

# Difference with merge:
# 'The advantages of the specific dplyr verbs is that they more clearly convey 
# the intent of your code: the difference between the joins is really important 
# but concealed in the arguments of merge(). dplyr’s joins are considerably 
# faster and don’t mess with the order of the rows.'

# 13.5 Filtering Joins

# Find the top 10 most popular destinations (total flights per year)

(top10 <- flights %>%
  count(dest) %>%
  filter(rank(desc(n)) < 11) %>%
  arrange(desc(n)))
  
# Get only the flights to the top destinations

flights %>% 
  filter(dest %in% top10$dest)
flights %>%
  semi_join(top10)

# Get the flights to the top 11 destinations
(ranked_dest <- flights %>%
  count(dest) %>%
  mutate(r = rank(desc(n))) %>%
  arrange(r))

flights %>%
  semi_join(filter(ranked_dest, r <= 11))
flights %>% 
  filter(dest %in% ranked_dest$dest[ranked_dest$r <= 11])

# `semi-join()` expresses intent clearer, more self-documenting.
# I prefer it.
# Semi-join is more convenient with multiple fields

(worst_days <- flights %>%
  group_by(year, month, day) %>%
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>%
  # This one got me! What happens if we drop this `ungroup()`?
  ungroup() %>%
  mutate(rank_delay = rank(desc(delay))) %>%
  arrange(rank_delay))

# Try this without semi-join
flights %>%
  semi_join(filter(worst_days, rank_delay <= 10))

# Anti-join gets the rows that do not match in the second table
flights %>% 
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = TRUE)

# 3 steps to make sure the join works
# 1. What is the primary key? Is it a primary key, i.e. it is unique?
# 2. Is the primary key present for all?
# 3. Do the primary and foreign keys match in the way we expect? Use anti_join for this

# Be aware of setdiff, intersect, and union

# Chapter 23

library(modelr)
library(ggplot2)
library(tidyverse)

# sim1 dataset comes with modelr
ggplot(sim1, aes(x,y)) + 
  geom_point()

# This creates a data frame of model parameters
(models <- tibble(
  a1 = runif(250, -20, 40),
  a2 = runif(250, -5, 5)
))

ggplot(sim1, aes(x,y)) + 
  geom_abline(data = models, aes(intercept= a1, slope= a2), alpha = 1/4) +
  geom_point()

# Take model and data and plots the model for all the x's in the data
# Computes the y-value for the x-value in the data, predicted by linear model a
model1 <- function(a, data) {
  a[1] + data$x * a[2]
}

model1(c(7, 1.5), sim1)

# mean-squared error is the benchmark error used
measure_distance <- function(mod, data) {
  diff <- data$y - model1(mod, data)
  sqrt(mean(diff^2))
}

# Helper function. 
# We need it to package two individual parameters into a single vector of parameters
sim1_dist <- function(a1, a2) {
  measure_distance(c(a1, a2), sim1)
}

# Some nice functional code (my kind of thing)
# Computes the distance for every model
models <- models %>%
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))

models
# Get the best models
(top_models <- models %>%
  filter(rank(dist) <= 10))

# Plot the lines of the best models
ggplot(sim1, aes(x,y)) + 
  geom_point() + 
  geom_abline(data = top_models, aes(intercept = a1, slope = a2, color = -dist))

# Now plot the parameters for all our models
# Highlight the best models
ggplot(models, aes(a1, a2, color = -dist)) + 
  geom_point(data = filter(models, rank(dist) <= 10), size = 4, color = 'red') + 
  geom_point()

# This was a weird way of getting OK models
# Let's use buil-in optimization tools to find the 'optimal' values of parameters
# It optimizes (minimizes) the function we tell it, and starts at c(0,0) in this case
best <- optim(c(0,0), measure_distance, data = sim1)
best$par

# That looks much better!
ggplot(sim1, aes(x,y)) + 
  geom_point() + 
  geom_abline(intercept = best$par[1], slope = best$par[2])

# finding the 'best' linear model is so common, it's built in (or coures)
sim1_mod <- lm(y ~ x, data = sim1)
# Check the parameter is the same
coef(sim1_mod)

# This is the right way of doing it, but the `optim()` generalizes to
# other types of cost functions etc. You should know about it, 
# for most of you only so you realize this is what some functions do in
# the background (well, a generalized version of it). 
# That's why you sometimes have to specify a seed or starting point
# as well as a loss or cost function

# Add predictions and residuals to df
# Convenience functions provided by modelr
(df <- sim1 %>%
  add_predictions(sim1_mod) %>%
  add_residuals(sim1_mod))

# Plot the predicted points. Obviously they are on the line.
ggplot(df, aes(x,y)) + 
  geom_point() +
  geom_point(aes(x,pred), color = "red") + 
  geom_abline(aes(intercept = coef(sim1_mod)[1], slope = coef(sim1_mod)[2]), color = "red")

# Do the residuals look randomish? 
ggplot(df, aes(x, resid)) + 
  geom_point()

# You can also use predict and residuals from base R, but make sure you haven't
# changed the order of the rows on the dataset!
(df <- df %>%
  mutate(
    pred2 = predict(sim1_mod),
    resid2 = residuals(sim1_mod)
    ))

# New dataset to illustrate other linear models and how we can specify them
ggplot(sim3, aes(x1, y, color = x2)) + 
  geom_point()

mod1 <- lm(y ~ x1 + x2, data = sim3)
mod2 <- lm(y ~ x1 * x2, data = sim3)

mod1
mod2
summary(mod1)
summary(mod2)

diamonds

# You can use transformations in formulas
dm1 <- lm(log(price) ~ carat, data = diamonds)
summary(dm1)

# You have to wrap parts of the formula that use *, +, - or ^ into I(), in order to have correct
# interpretations. 
dm2 <- lm(price ~ carat + carat^2, data = diamonds)
dm3 <- lm(price ~ carat + I(carat^2), data = diamonds)
dm4 <- lm(price ~ carat + carat*carat, data = diamonds)
dm5 <- lm(price ~ carat + I(carat*carat), data = diamonds)

diamonds %>%
  add_residuals(dm5) %>%
  add_predictions(dm5) %>%
  ggplot(aes(carat, price)) + 
  geom_point() + 
  geom_point(aes(x = carat, y = pred), color = "red")

# Whenever transformations get complicated, do the transformation first on 
# the data frame, then write the formula simply

# Assignment

# Exercise 1. Merge the two Vienna datasets into one. Which hotels do not have 
# matches in the price data? Use anti_join.
#
# Exercise 2. Come up with 3 models to explore what drives the price of 
# hotels in Vienna. Plot the price of hotels against some of the main variables
# that seem to have the most explanatory power.

# Exercise 3. Look at the residuals from your favorite model. Now plot these 
# against 3 variables that you didn't include earlier - or if you included all
# plot them agains some variables in a form that you did not do before 
# (squares, logs, interactions). Do the residuals look random? 

# Exercise 4. Try to find out some methods to check if residuals are random and 
# how to code this in R. Find at least two ways.

# Exercise 5. Use your model estimated on Vienna to predict prices for another city.
# How well does your model do, if you use the parameter values estimated on Vienna?

# Exercise 6. Reestimate your favorite model (the same as from exercise 1) for
# another city. How much do the parameter values change? How well does the model
# do now? If you had to summarise the difference between the 2 cities in one 
# number based on your model, what would it be?