# Lecture 10 class notes

library(tidyverse)

# Plot Brownian Motions (BMs)

plot_BM <- function(N) { 
  # TODO refactor
  all_steps <- sign(runif(N, min = -0.5, max = 0.5))
  all_xs <- cumsum(all_steps)
  df <- tibble(time = 1:N, position = all_xs)
  ggplot(df, aes(x = time, y = position)) + 
    geom_line()
}

plot_BM(1000)

# But this is bad design
# This function does two things:
# 1. Get a BM (the xs)
# 2. Plot it

get_steps <- function(N) {
  sample(c(-1,1), N, replace = TRUE)
}

get_BM <- function(N) {
  cumsum(get_steps(N))
}

plot_BM <- function(bm) {
  df <- tibble(time = 1:length(bm), position = bm)
  ggplot(df, aes(time, position)) +
    geom_line()
}

plot_BM(get_BM(500))

bm1 <- get_BM(500)
plot_BM(bm1)

# Let's plot the histogram of a BM after 500 steps

bm1
res <- replicate(n = 1000, expr = get_BM(500)[500])
res[1:10]
hist(res)

bms <- replicate(n = 1000, expr = get_BM(500))
bms[,1]
bms[,2]
bms[,1000]
hist(bms[400, ])
hist(bms[500, ])
hist(bms[100, ])

# Dice rolls
# roll 3 dices! 1-6 x 3
sample(1:6, 3, replace = TRUE)

# roll 3 dice 1k times and plot the sum of points
set.seed(42)
runif(1)
set.seed(42)
dices <- function() {sample(1:6, 3, replace = TRUE)}
dices_sum <- function() {sum(dices())}
dices_sum()
dices_sum
dices_sum()
hist(replicate(1000, dices_sum()))

df <- tibble(x = replicate(1e5, dices_sum()))
ggplot(df, aes(x)) + geom_histogram()
ggplot(df, aes(x)) + geom_histogram(binwidth = 1)
ggplot(df, aes(x)) + geom_histogram(bins = 16)
ggplot(df, aes(x)) + geom_bar()

# install.packages("lubridate")

# Chapter 16 (R4DS)

library(tidyverse)
library(lubridate)
library(nycflights13)

# Three types of objects (as for SQL):
# - Date
# - Time
# - Datetime

# If you want to work with time alone, do library(hms)

today()
now()

ymd("2017-01-03")
mdy("January 31st, 2017")
dmy("31-Jan-2017")
ymd("2017/01/03")
dmy("31-January-2017")
dmy("31-1-2017")
mdy("1 31st, 2017")
mdy("January 31st, 2017")
