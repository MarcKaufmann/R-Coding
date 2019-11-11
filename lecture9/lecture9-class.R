# Lecture 9

# Illustration of exercises 5 and 6 of lecture 8

vienna_model_estimate <- lm(price ~ distance, data = my_vienna_data)

# This will give some coefficients, e.g. distance para is 2.35

# Ex 5
# What do these parameters predict for London?

# Ex 6

london_model_estimate <-lm(price ~ distance, data = my_london_data)
# you might get a parameter of 3.7

library(modelr)
library(ggplot2)
library(tidyverse)

sim1
sim1_mod <- lm(y ~ x, data = sim1)
sim1_mod
sim1_mod_no_intercept <- lm(y ~ x - 1, data = sim1)
sim1_mod_no_intercept
coef(sim1_mod)
sim1_mod$coefficients

# Add predictions and residuals, defined in modelr
(df <- sim1 %>%
    add_predictions(sim1_mod) %>%
    add_residuals(sim1_mod))

# Plot it
ggplot(df, aes(x, y)) +
  geom_point() + 
  geom_point(aes(x, pred), color = "red") + 
  geom_abline(aes(intercept = coef(sim1_mod)[1], 
                  slope = coef(sim1_mod)[2]), 
              color = "red")


# They have to have mean 0, because we minimize MSE
ggplot(df, aes(x, resid)) + 
  geom_point()

# Base R for predict and resid
(df <- df %>%
    mutate(
      pred2 = predict(sim1_mod),
      resid2 = residuals(sim1_mod)
    ))

# Other linear models and how to specify them
ggplot(sim3, aes(x1, y, color = x2)) +
  geom_point()

mod1 <- lm(y ~ x1 + x2, data = sim3)
mod2 <- lm(y ~ x1 * x2, data = sim3)

sim3 <- sim3 %>%
  add_predictions(mod1, var = "mod1") %>%
  add_predictions(mod2, var = "mod2")

# x1 * x2: Means try a different x1 for every value of x2
ggplot(sim3, aes(x = x1, y = y, color = x2)) + 
  geom_point() + 
  geom_line(aes(y = mod2))

ggplot(sim3, aes(x = x1, y = y, color = x2)) + 
  geom_point() + 
  geom_line(aes(y = mod1))

mod1
mod2

summary(mod1)

# You can use transforms
dm1 <- lm(log(price) ~ carat, data = diamonds)
summary(dm1)

dm2 <- lm(price ~ carat + carat^2, data = diamonds)
dm3 <- lm(price ~ carat + I(carat^2), data = diamonds)
dm4 <- lm(price ~ carat + carat*carat, data = diamonds)
dm5 <- lm(price ~ carat + I(carat*carat), data = diamonds)

diamonds %>%
  add_residuals(dm5) %>%
  add_predictions(dm5) %>%
  ggplot(aes(carat, price)) + 
  geom_point() + 
  geom_point(aes(x = carat, y = pred), color = 'red')

# Whenever there are complicated transformations, just do it
# in the dataframe (i.e. before doing lm(...))

# Functions, iterations, conditional and all that

square_func <- function(x) {
  x^2
}

square_func(4)
square_func(12)

cube_func <- function(my_silly_name) {
  return(my_silly_name^3)
}

cube_func(4)

my_sqrt <- function(x) {
  if (x < 0) {
    "not allowed"
  } else {
    return(sqrt(x))
  }
}

my_sqrt(4)
my_sqrt(-4)

# Based on 'R skills' by Gergo Daroczi, lecture 1  and 2
# Simulate brownian motions (BM)
# BM: you go forward or backward 1 step every period
# With equal probability
# How far are you after N steps (can be negative)
# Important in physics, in finance, in lots of things

# Get 1 step +1 or -1 with equal probability
sign(runif(1, min = -0.5, max = 0.5))

# We want to get multiple steps
# Set the seed for pseudo-random number generation to make
# debugging (and testing) easier, because non-random
set.seed(42)
x <- 0
step1 <- sign(runif(1) - 0.5)
x <- x + step1
step2 <- sign(runif(1) - 0.5)
x <- x + step2
next_step <- function() {
  sign(runif(1) - 0.5)
}
(x <- x + next_step())
(x <- x + next_step())

# loop approach
set.seed(42)
x <- 0
for (i in 1:25) {
  print(i)
  print(x)
  x <- x + next_step()
}
x

## vectorized approach

set.seed(42)
(all_steps <- sign(runif(25) - 0.5))
(x <- sum(all_steps))

# What if we want intermediate steps:
cumsum(all_steps)
ggplot(mapping = aes(x = 1:25, y = cumsum(all_steps))) + 
  geom_point() + 
  geom_line()

# What if we want BMs of different lengths:

plot_BM <- function(N) {
  # TODO: Refactor
  all_steps <- sign(runif(N) - 0.5)
  all_xs <- cumsum(all_steps)
  df <- tibble(time = 1:N, position = all_xs)
  ggplot(df, aes(x = time, y = position)) + 
    # geom_point() + 
    geom_line()
}

plot_BM(25)
plot_BM(100)
plot_BM(5000)

# What if we want to use the data of the BMs plotted?
# Bad design of function
# A function should (ideally) do one thing

