# Lecture 9
sim3

# Chapter 23 continued

library(modelr)
library(ggplot2)
library(tidyverse)

# finding the 'best' linear model is so common, it's built in (or coures)
sim1_mod <- lm(y ~ x, data = sim1)
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

# Note: they have mean 0. Must hold whenever we minimize the mean-squared error.

# You can also use predict and residuals from base R, but make sure you haven't
# changed the order of the rows on the dataset.
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

sim3 <- sim3 %>%
  add_predictions(mod1, var = "mod1") %>%
  add_predictions(mod2, var = "mod2")

# Plot model 1 lines
ggplot(sim3, aes(x = x1, y = y, color = x2)) +
  geom_point() +
  geom_line(aes(y = mod1))

# Plot model 2 lines
ggplot(sim3, aes(x = x1, y = y, color = x2)) +
  geom_point() +
  geom_line(aes(y = mod2))

# It would be nice to plot both next to each other.
# We can use facet_wrap for this, but have to tell it which data
# goes into which facet, thus we should gather all models
# into one column.

(sim3 <- sim3 %>%
  gather(key = model, value = pred, mod1, mod2))

ggplot(sim3, aes(x = x1, y = y, color = x2)) +
  geom_point() +
  geom_line(aes(y = pred)) +
  # Docs say to use vars(model). Don't ask me why. 
  facet_wrap(vars(model))

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

# Functions, Iterations, Conditionals and all that

# For those with background in programming, feel free to leave
# Make sure to quickly scan the code, but you should be fine

# How to plot a function with ggplot

square_func <- function(x) {x^2}
cube <- function(x) {x^3}

# Note on return()

p <- ggplot(data = data.frame(x = 0), mapping = aes(x = x))
p + 
  # What happens if I add color = 'square' without aes()?
  stat_function(fun = square_func, aes(color = 'square')) + 
  stat_function(fun = cube, aes(color = 'cube')) +
  xlim(-5,5)

# Based on R skills by Gergo Daroczi, lectures 1 and 2

## Simulate Brownian motion (random walk) in 1D
# BM is: You go forward or backward 1 step every period
# You do so with equal probability.
# The question is: where are you after N steps?
# Important in physics, in finance, in lots of things

# First, get +1 or -1 with equal probability
sign(runif(1, min = -0.5, max = 0.5))

## loop approach
# If you want to be able to replicate bugs, make sure to set the seed
# This means you get the same 'random' sequence each time
set.seed(42)
x <- 0
step1 <- sign(runif(1) - 0.5)
x <- x + step1
step2 <- sign(runif(1) - 0.5)
x <- x + step2
# ... getting bored already. First, let's define a next_step function
next_step <- function() {
  sign(runif(1) - 0.5)
}

(x <- x + next_step())
(x <- x + next_step())
# ... getting bored again
# Let's start again
set.seed(42)
x <- 0
for (i in 1:25) {
    x <- x + next_step()
}
x

## vectorized approach
# vectorized things are special forms of for loops
# Reset seed for comparison
set.seed(42)
(all_steps <- sign(runif(25, min = -0.5, max = 0.5)))
(x <- sum(all_steps))

# Even nicer than the for loop
# What if we want the whole evolution of the BM?
cumsum(all_steps)
ggplot(mapping = aes(x = 1:25, y = cumsum(all_steps))) + 
  geom_point() +
  geom_line()

# What if we want to plot BMs of various lengths?

plot_BM <- function(N) {
  # TODO: Refactor, I keep typing the same parameters again and again. 
  all_steps <- sign(runif(N, min = -0.5, max = 0.5))
  all_xs <- cumsum(all_steps)
  df <- tibble(time = 1:N, position = all_xs)
  ggplot(df, aes(x = time, y = position)) +
    #geom_point() + 
    geom_line()
}

plot_BM(25)
plot_BM(250)
plot_BM(2500)

# But... what if we want to use the data of these BMs? We now only have the plot.
# Bad design of the function. 
# A function should (ideally) do one thing.

get_steps <- function(n) {
  sample(c(-1,1), N, replace = TRUE)
}

get_BM <- function(N) {
  #all_steps <- sign(runif(N, min = -0.5, max = 0.5))
  all_xs <- cumsum(get_steps(N))
  return(all_xs) # Not necessary, as default is to return last thing
}

plot_BM <- function(bm) {
  df <- tibble(time = 1:length(bm), position = bm)
  ggplot(df, aes(x = time, y = position)) +
    geom_line()
}

# We can do as before:
plot_BM(get_BM(500))

# But we can also first get the BM if we need it:
bm1 <- get_BM(500)
plot_BM(bm1)

# What if we want to plot multiple BMs? See Appendix to these lecture notes

## Plot the histogram of results for where a BM is after 500 steps. 
res <- replicate(n = 1000, expr = get_BM(500)[500])
hist(res) # Good for quick and dirty, not good for publication and reports.

## Plot the histogram at the 400th iteration
res <- replicate(n = 1000, expr = get_BM(500)[400])
hist(res)

# But it makes more sense to compute the BMs once, then get differnt positions.
bms <- replicate(n = 1000, expr = get_BM(500))
head(bms)

# Can you tell whether a single BM is in a row or in a column?
# It is in a column. So the Nth row (the first number) gives the Nth observation
# for every BM.
hist(bms[400,])

## TODO roll 3 dices! 1-6 x 3
sample(1:6, 3, replace = TRUE)

## TODO roll 3 dices 1K times and plot the sum of points
set.seed(42)
dices <- function() {sample(1:6, 3, replace = TRUE)}
dices_sum <- function() {sum(dices())}
dices_sum()
hist(replicate(1000, dices_sum()))
## NOTE interesting, should be symmetric?

df <- tibble(x = replicate(1e5, dices_sum()))
ggplot(df, aes(x = x))  + 
  geom_histogram()
ggplot(df, aes(x = x))  + 
  geom_histogram(bins = 16)
ggplot(df, aes(x = x)) +
  geom_bar()
# Lesson: Use bar charts for discrete data, histogram for continuous
# In base R:
hist(replicate(100000, dices_sum()))
hist(replicate(1e5, dices_sum()))
hist(replicate(1e5, dices_sum()), breaks = 2:18)
table(replicate(1e5, dices_sum()))
barplot(table(replicate(1e5, dices_sum())))

# Appendix

# OPTIONAL: For the curious, if you plan on writing functions with ggplot.
# I'll skip it, since there is some rather esoteric stuff going on
# to get it working. Namely, see the use of aes_ (note the underscore).
# There is a tidy way (meaning to use the tidyverse way of thinking) to do it too.
# Our plotting function is a little too specific
# Let's pass in a list of BMs, and make sure to say what time to plot

# Read this in your own time if you want to know why you should *not*
# use for loops with ggplot.

plot_BMs_bug <- function(lbm, N) {
  p <- ggplot()
  for (bm in lbm) {
    p <- p + geom_line(mapping = aes(x = 1:N, y = bm))
  }
  return(p)
}

plot_BMs <- function(lbm, N) {
  p <- ggplot()
  for (bm in lbm) {
    p <- p + geom_line(mapping = aes_(x = 1:N, y = bm))
  }
  return(p)
}

list_of_bms <- list(get_BM(5), get_BM(5), get_BM(5))
plot_BMs(list_of_bms, 5)
plot_BMs_bug(list_of_bms, 5)

# The bug is somewhat subtle.
# See https://stackoverflow.com/questions/26235825/for-loop-only-adds-the-final-ggplot-layer
# Lesson: Do *not* put ggplot in a for loop. Bugs will ensue.

