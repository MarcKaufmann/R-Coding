# Lecture 11

library(modelr)
library(ggplot2)
library(tidyverse)

sim1

ggplot(sim1, aes(x, y)) +
  geom_point()

(sim1_mod <- lm(y ~ x, data = sim1))
sim1_mod
str(sim1_mod)
coef(sim1_mod)[2]
sim1_mod$coefficients

# Add predictions and residuals 
(df <- sim1 |>
    add_predictions(sim1_mod) |>
    add_residuals(sim1_mod))

# Plot it
ggplot(df, aes(x, y)) + 
  geom_point() +
  geom_point(aes(x, pred), color = "red") +
  geom_abline(aes(
    intercept = coef(sim1_mod)[1],
    slope = coef(sim1_mod)[2]
  ), color = "red")

# The residuals should have mean 0, because we minimize MSE
ggplot(df, aes(x, resid)) + 
  geom_point()

# Base R for predict and resid
(df <- df |>
    mutate(
      pred2 = predict(sim1_mod),
      resid2 = residuals(sim1_mod)
    ))

predict(sim1_mod)

# Functions, interations, conditional and all that

square_func <- function(x) {
  x^2
}
square_func(4)

my_sqrt <- function(x) {
  if (x < 0) {
    "not allowed"
  } else {
    return(sqrt(x))
  }
}

my_sqrt(4)
my_sqrt(-4)

# simulation of Brownian Motions

# Get 1 step +1 or -1 with equal probability
# Based on 'R skills' lecture by Gergo Daroczi

sign(runif(10, min = -0.5, max = 0.5))

x <- 0
step1 <- sign(runif(1) - 0.5)
x <- x + step1
x
step2 <- sign(runif(1) - 0.5)
x <- x + step2
x
next_step <- function() {
  sign(runif(1) - 0.5)
}
(x <- x + next_step())
(x <- x + next_step())

set.seed(42)
x <- 0
for (i in 1:10) {
  print(paste("i:", i))
  x <- x + next_step()
  print(paste("x:", x))
}

set.seed(42)
(all_steps <- sign(runif(100) - 0.5))
(x <- sum(all_steps))
(xs <- cumsum(all_steps))

ggplot(mapping = aes(x = 1:100, y = cumsum(all_steps))) +
  geom_line()

plot_BM_tmp <- function(N) {
  all_steps <- sign(runif(N) - 0.5)
  all_xs <- cumsum(all_steps)
  df <- tibble(time = 1:N, position = all_xs)
  ggplot(df, aes(x = time, y = position)) + 
    geom_line()
}

plot_BM_tmp(25)
plot_BM_tmp(100)
plot_BM_tmp(1000)

generate_BM <- function(N) {
  all_steps <- sign(runif(N) - 0.5)
  all_xs <- cumsum(all_steps)
  tibble(time = 1:N, position = all_xs)
}

plot_BM <- function(bm) {
  ggplot(bm, aes(x = time, y = position)) + 
    geom_line()
}

bm1 <- generate_BM(1000)
plot_BM(bm1)
mean(bm1$position)
