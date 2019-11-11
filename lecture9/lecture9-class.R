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


# Assignment

# Optional Exercise 0 for non-programmers (if you get stuck): 
# If you wonder how to write functions, read chpater 19 in R4DS.
#
# Important note: It is very hard to write functions well, since at the deep level it is about
# how to organize your code, which is about understanding what it is you want to do
# and how to express this succinctly, clearly, and correctly. Defining a single simple function
# is very easy - such as defining a function that computes the square. But knowing
# which functions to write, how to make them play nicely with each other, how to not
# repeat code, etc etc is hard. I say this so you realize that it is normal to be confused,
# and to remain confused. I certainly am confused by some of the higher-level functions,
# by modules/libraries/packages (which are a kind of mega-function), by macros (another
# type of mega-function, but in a different direction), etc etc. So be patient with yourself,
# try to take it one small step at a time and to get the job done, without expecting to 
# understand everything.
# 
# Optional Exercise 0 (no need to report on it, but I recommend it for educational purposes): 
# Read https://r4ds.had.co.nz/iteration.html#the-map-functions, section 21.5 on map functions,
# especially if you come from imperative or object-oriented languages. If you know how to use
# map functions, the pipe and functional style starts to become substantially more powerful,
# while if you still think in OO ways, you will constantly fight the way the tidyverse works.
# This is not to say that this type of functional programming is better, but that it is the
# way the tidyverse is organized, and that it has a lot going for it. If after you grok maps
# you still don't like it, that's fine. At least you know what you don't like.

# Exercise 1: Map each coefficient from mod1 and mod2 to a feature of the plot 
# with two facets. For instance, what is x1 in summaryd(mod2)? Where could you
# read it off (roughly) from the graph? Etc for x1:x2b and so on. If you get
# stuck, do ask for specific questions on Discourse. Correct answers for any 
# parameter look like this:
# x1 is the [slope/intercept/difference between slopes/intercepts of] for ... 
# Since it is [positive/negative] this means that ... is [larger/smaller] than ...

# Exercise 2: Do the faceting with gather_predictions and if needed with data_grid.
# Look at chapter 23 for help.

# Exercise 3: Read/Skim 21.2, 21.3, and 21.4 so you are aware of some issues.
# Pick a short example from the notes that you feel you want to understand better
# and use some other use case to illustrate it (using the Vienna data, or 
# diamonds, or the same but in a different way.)
