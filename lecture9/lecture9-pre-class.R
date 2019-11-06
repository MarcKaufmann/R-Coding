# Lecture 9

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

# Functions, Iterations, Conditionals and all that

# How to plot a function with ggplot

square_func <- function(x) {x*x}

p <- ggplot(data = data.frame(x = 0), mapping = aes(x = x))t
p + stat_function(fun = square_func) + xlim(-5,5)

# More general example:

p +
    layer(stat = "function",
          fun = fun.1,
          mapping = aes(color = "fun.1")
          ) +
    layer(stat = "function",
          fun = fun.2,
          mapping = aes(color = "fun.2")
          ) +
    layer(stat = "function",
          fun = fun.3,
          mapping = aes(color = "fun.3")
          ) +
    scale_x_continuous(limits = c(-5, 5)) +
    scale_color_manual(name = "Functions",
                       values = c("blue", "red", "green"), # Color specification
                       labels = c("X^2 + X", "-X + 10", "3X + 2"))

# FROM GERGO LECTURE 1.R

## TODO simulate Brownian motion (random walk) in 1D
round(runif(1))
round(runif(1))*2 - 1
sign(runif(1) - 0.5)
sign(runif(1, min = -0.5, max = 0.5))

## loop approach
set.seed(42)
x <- 0
for (i in 1:25) {
    x <- x + sign(runif(1) - 0.5)
}
x

## vectorized approach
round(runif(5))
round(runif(5))*2 - 1
cumsum(round(runif(25))*2 - 1)

plot(cumsum(round(runif(25))*2 - 1), type = 's')

## plot multiple simulations
set.seed(42)
plot(cumsum(round(runif(25))*2 - 1), type = 's')

for (i in 2:6) {
    lines(cumsum(round(runif(25))*2 - 1), type = 's', col = i)
}

## pro tipp: set ylim to accommodate all possible outcomes
plot(c(1, 25), c(-25, 25), type = 'n')
plot(NULL, NULL, xlim = c(1, 25), ylim = c(-25, 25))

## pro tipp: use "sample" instead of transforming a random number between 0 and 1
sample(c(-1, 1), 25, replace = TRUE)

## pro tipp: create a new function generating these numbers
minus_or_plus <- function(n) {
    sample(c(-1, 1), n, replace = TRUE)
}
minus_or_plus(5)

## TODO plot a histogram of results running the above simulation for 1K times each with 500 rounds
res <- replicate(n = 1000, expr = sum(minus_or_plus(500)))
hist(res)

## TODO plot the histogram at the 400th iteration
res <- replicate(n = 1000, expr = sum(minus_or_plus(400)))
hist(res)

res <- replicate(n = 1000, expr = cumsum(minus_or_plus(500)))
hist(res[400, ])

res <- lapply(1:1000, function(i) cumsum(minus_or_plus(500)))
str(res)
res <- do.call(cbind, res)
hist(res[400, ])

## better to store simulations in rows
res <- lapply(1:1000, function(i) cumsum(minus_or_plus(500)))
str(res)
res <- do.call(rbind, res)
hist(res[, 400])

## NOTE simplify it right away
res <- sapply(1:1000, function(i) cumsum(minus_or_plus(500)))
str(res)

## TODO plot a histogram doing the same simulation but after the 100th, 200th, 300th etc iteration
library(animation)
saveGIF({
    for (i in 1:500) {
        hist(res[i, ])
    }
})

library(animation)
ani.options(interval = 0.5)
saveGIF({
    for (i in seq(1, 500, by = 25)) {
        hist(res[i, ], main = i)
        abline(v = mean(res[i, ]), col = 'red')
    }
})

## TODO compute the minimum value for each simulation
?lapply
?sapply
?replicate
?apply

apply(res, 1, min)
apply(res, 2, min)

# FROM GERGO LECTURE 2

## recap from last week
minus_or_plus <- function(n) {
    sample(c(-1, 1), n, replace = TRUE)
}
minus_or_plus(5)

res <- replicate(n = 1000, expr = sum(minus_or_plus(500)))
str(res)
hist(res)

res <- lapply(1:1000, function(i) cumsum(minus_or_plus(500)))
res <- do.call(cbind, res)
str(res)
hist(res[500, ])

res <- sapply(1:1000, function(i) cumsum(minus_or_plus(500)))
str(res)
hist(res[500, ])

## TODO rerun with setting the rnd seed to 42
set.seed(42)
res <- sapply(1:1000, function(i) cumsum(minus_or_plus(500)))

## TODO list all simulation when the value did not become negative
which(apply(res, 2, min) > 0)
## eg
res[, 23]

## TODO roll 3 dices! 1-6 x 3
sample(1:6, 3, replace = TRUE)

## TODO roll 3 dices 1K times and plot the sum of points
dices <- function() sample(1:6, 3, replace = TRUE)
dices_sum <- function() sum(dices())
dices_sum()
hist(replicate(1000, dices_sum()))
## NOTE interesting, should be symmetric?

hist(replicate(100000, dices_sum()))
hist(replicate(1e5, dices_sum()))
table(replicate(1e5, dices_sum()))
barplot(table(replicate(1e5, dices_sum())))
hist(replicate(1e5, dices_sum()), breaks = 2:18)

## TODO how many times out of 1K rolls we had the same points on each dice?
set.seed(42)
res <- replicate(1000, dices())
str(res)
which(apply(res, 2, sd) == 0)
res[, 58]
length(which(apply(res, 2, sd) == 0))

## TODO playing on roulette – always bet on red (or 18-36)
roulette <- function() sample(0:36, 1)
wallet <- 100
bet <- 1
for (i in 1:100) {
    wallet <- wallet - bet
    number <- roulette()
    if (number > 18) {
        cat('win!\n')
        wallet <- wallet + bet * 2
    } else {
        cat('lost :(\n')
    }
}
wallet

## advanced logging
library(futile.logger)
flog.info('Win!')
flog.error('Duh :/')

## TODO vectorize
sum(ifelse(sample(0:36, 100, replace = TRUE) > 18, 1, -1))

## #############################################################################

## NOTE read.csv -> readxl from the Internet for MDS

## distance between 40 Hungarian cities -> 2D scatterplot
download.file('http://bit.ly/hun-cities-distance', 'cities.xls')
## on windows
download.file('http://bit.ly/hun-cities-distance', 'cities.xls', mode = 'wb')

library(readxl)
cities <- read_excel('cities.xls')
str(cities)

## get rid of 1st column and last row (metadata)
cities <- cities[, -1]
cities <- cities[-nrow(cities), ]

mds <- cmdscale(as.dist(cities))
mds

plot(mds)
text(mds[, 1], mds[, 2], names(cities))

## flipping both x and y axis
mds <- -mds
plot(mds)
text(mds[, 1], mds[, 2], names(cities))

## non-geo example
?mtcars
str(mtcars)
mtcars

mds <- cmdscale(dist(mtcars))
plot(mds)
text(mds[, 1], mds[, 2], rownames(mtcars))

mds <- as.data.frame(mds)
library(ggplot2)
ggplot(mds, aes(V1, -V2, label = rownames(mtcars))) +
    geom_text() + theme_bw()

library(ggrepel)
ggplot(mds, aes(V1, -V2, label = rownames(mtcars))) +
    geom_text_repel() + theme_bw()

## NOTE think about why the above visualization is off

# Assignment


