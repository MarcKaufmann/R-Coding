# Lecture 9

library(modelr)
library(ggplot2)
library(tidyverse)

sim1
sim1_mod <- lm(y ~ x, data = sim1)
sim1_mod
summary(sim1_mod)
sim1_mod_no_intercept <- lm(y ~ x - 1, data = sim1)
sim1_mod_no_intercept
coef(sim1_mod)[2]
str(sim1_mod)
sim1_mod$coefficients
sim1_not_square <- lm(y ~ x + x*x, data = sim1)
sim1_not_square
sim1_square <- lm(y ~ x + I(x*x), data = sim1)
sim1_square
sim1b <- sim1 %>%
  mutate(sq = x*x) # Can I pass with pipe to second (or third...) argument?
lm(y ~ x + sq, data = sim1b)

# Add predictions and residuals, defined in modelr
(df <- sim1 %>%
  add_predictions(sim1_mod) %>%
  add_residuals(sim1_mod))

ggplot(df, aes(x, y)) + 
  geom_point() + 
  geom_point(mapping = aes(y = pred), color = "red") + 
  geom_abline(aes(
    intercept = coef(sim1_mod)[1],
    slope = coef(sim1_mod)[2]
  ), color = "red")
  # geom_smooth(mapping = aes(y = pred), method = "lm", color = "yellow")

# Residuals next
df %>%
  mutate(sq = x*x) %>%
  ggplot(aes(sq, resid)) + 
  geom_point()

# Base R
(df <- df %>%
    mutate(
      pred2 = predict(sim1_mod),
      resid2 = residuals(sim1_mod)
    ))

# Richer linear models
sim3
ggplot(sim3, aes(x1, y, color = x2)) + 
  geom_point()

mod1 <- lm(y ~ x1 + x2, data = sim3)
mod2 <- lm(y ~ x1*x2, data = sim3)
mod2b <- lm(y ~ x1 + x2 + x1:x2, data = sim3)

mod2
mod2b

sim3 <- sim3 %>%
  add_predictions(mod1, var = "mod1") %>%
  add_predictions(mod2, var = "mod2")
sim3

ggplot(sim3, aes(x = x1, y = y, color = x2)) + 
  geom_point() + 
  geom_line(aes(y = mod2))

ggplot(sim3, aes(x = x1, y = y, color = x2)) + 
  geom_point() + 
  geom_line(aes(y = mod1))

sim3 <- sim3 %>%
  mutate(
    x3 = case_when(
      x2 == "a" ~ 1,
      x2 == "b" ~ 2,
      x2 == "c" ~ 3,
      x2 == "d" ~ 4
    )) 
  
mod3 <- lm(y ~ x1 + x3, data = sim3)
sim3 <- sim3 %>%
  add_predictions(mod3, var = "mod3")

# Question: What will happen if we change x2 to x3? Will colors remain the same?
ggplot(sim3, aes(x = x1, y = y, color = x2)) + 
  geom_point() + 
  geom_line(aes(y = mod3))

summary(mod1)

# We can use transforms in models
diamonds
dm1 <- lm(log(price) ~ carat, data = diamonds)
summary(dm1)

dm2 <- lm(price ~ carat + carat^2, data = diamonds)
dm3 <- lm(price ~ carat + I(carat^2), data = diamonds)
dm4 <- lm(price ~ carat + carat*carat, data = diamonds)
dm5 <- lm(price ~ carat + I(carat*carat), data = diamonds)

summary(dm2)
summary(dm4)
summary(dm3)
summary(dm5)

diamonds %>%
  add_residuals(dm5) %>%
  add_predictions(dm5) %>%
  ggplot(aes(carat, price)) + 
  geom_point() + 
  geom_point(aes(y = pred), color = 'red')

diamonds %>%
  add_residuals(dm5) %>%
  add_predictions(dm5) %>%
  ggplot(aes(carat, resid)) + 
  geom_point()

dm6 <- lm(log(price) ~ carat, data = diamonds)

diamonds %>%
  add_residuals(dm6) %>%
  add_predictions(dm6) %>%
  ggplot(aes(carat, resid)) + 
  geom_point()

diamonds %>%
  add_residuals(dm6) %>%
  add_predictions(dm6) %>%
  ggplot(aes(carat, log(price))) + 
  geom_point() +
  geom_point(aes(y = pred), color = "red")

# Functions, iterations, conditionals and all that
square_func <- function(x) {
  #x + x
  #x*3
  #print("I have computed it.")
  x*x
}

square_func(2)
square_func(4)

cube_func <- function(x) x^3
cube_func(4)

# Would not really work:
# quartic_func <- function(x) 
#    x*2
#    x^4
# quartic_func(4)

cube_func <- function(my_silly_name) {
  my_silly_name^3
}
cube_func(3)

sqrt(2)
sqrt(-2)
my_sqrt <- function(x) {
  if (x < 0) {
    "not allowed"
  } else {
    sqrt(x)
  }
}
my_sqrt(2)
my_sqrt(-2)

# When working with random numbers, use set.seed() to make code replicable
set.seed(42)
runif(10)
set.seed(42)
runif(10)
