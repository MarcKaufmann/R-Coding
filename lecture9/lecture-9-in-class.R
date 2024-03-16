library(modelr)
library(ggplot2)
library(tidyverse)

sim1
sim1_mod <- lm(y ~ x, data = sim1)
library(broom)
tidy(sim1_mod)
sim1_mod
sim1_mod_no_intercept <- lm(y ~ x - 1, data = sim1)
sim1_mod_no_intercept
summary(sim1_mod)
coef(sim1_mod)
str(sim1_mod)
sim1_mod$coefficients

sim_not_square <- lm(y ~ x + x*x, data = sim1)
sim_not_square
(sim_square <- lm(y ~ x + I(x*x), data = sim1))
sim1b <- sim1 |>
  mutate(sq = x*x)
summary(lm(y ~ x + sq, data = sim1b))

# Add predictions and residuals
library(broom)

(df <- augment(sim1_mod))

(v <- sim1_mod$coefficients)
v[1]
v[2]

ggplot(df, aes(x = x, y = y)) + 
  geom_point() +
  geom_point(mapping = aes(y = .fitted), color = "red") +
  geom_abline(aes(
    intercept = coef(sim1_mod)[1],
    slope = coef(sim1_mod)[2]
  ), color = "red")


# Richer linear models
sim3 
ggplot(sim3, aes(x1, y, color = x2)) +
  geom_point()

mod1 <- lm( y ~ x1 + x2, data = sim3)
mod2 <- lm( y ~ x1*x2, data = sim3 )
mod2b <- lm( y ~ x1 + x2 + x1:x2, data = sim3)

mod1
mod2
mod2b

sim3_1 <- sim3 |>
  mutate(
    mod1 = augment(mod1)[[".fitted"]],
    mod2 = augment(mod2)$.fitted
  )
sim3_1

augment(mod1)


sim3_1 |>
  ggplot(aes(x = x1, y = y, color = x2)) + 
  geom_point() + 
  geom_line(aes(y = mod1))

sim3_1 |>
  ggplot(aes(x = x1, y = y, color = x2)) + 
  geom_point() + 
  geom_line(aes(y = mod2))

# Functions

square_func <- function(x) {
  #x + x
  #print("I will compute it...")
  x*x
}
three_squared <- square_func(3)
three_squared

sqrt(2)
sqrt(-2)

my_sqrt <- function(x) {
  if (x < 0) {
    "not allowed"
  } else {
    sqrt(x)
  }
}

my_sqrt(3)
my_sqrt(-3)

my_sqrt2 <- function(x) {
  ifelse( x < 0, "not allowed", sqrt(x))
}

my_sqrt2(3)
my_sqrt2(-3)

# random seed
runif(10)
runif(10)
set.seed(42)
runif(10)
set.seed(42)
runif(10)

