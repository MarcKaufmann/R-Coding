# Lecture 10

## Code a Brownian Motion

set.seed(42)
x <- runif(1)
set.seed(42)
y <- runif(1)
y

x <- 0
# One step of BM
step1 <- sign(runif(1) - 0.5)
step1
x <- x + step1
step2 <- sign(runif(1) - 0.5)
x <- x + step2
next_step <- function() {
  res <- sign(runif(1) - 0.5)
  print(res)
  res
}
(x <- x + next_step())
(x <- x + next_step())

# loop approach
set.seed(42)
x <- 0 # Starting point
for (i in 1:25) {
  print(c("step: ", i))
  x <- x + next_step()
  print(c("value: ", x))
}
x

# vectorized approach
set.seed(42)
x <- 0
(all_steps <- sign(runif(25) - 0.5))
(x <- sum(all_steps))

# What if we want the intermediate steps?
library(ggplot2)
cumsum(all_steps)
ggplot(mapping = aes(x = 1:25, y = cumsum(all_steps))) + 
  geom_point() + 
  geom_line()

library(dplyr)
plot_BM <- function(N) {
  all_steps <- sign(runif(N) - 0.5)
  all_xs <- cumsum(all_steps)
  df <- tibble(time = 1:N, position = all_xs)
  ggplot(df, aes(x = time, y = position)) +
    # geom_point() +
    geom_line()
}

plot_BM(25)
plot_BM(100)
plot_BM(1000)

# Bad design. This function does two things:
# 1. Get a BM (the xs)
# 2. Plot it

get_steps <- function(N) {
  sample(c(-1, 1), N, replace = TRUE)
}
get_steps(25)

get_BM <- function(N) {
  cumsum(get_steps(N))
}

plot_BM <- function(bm) {
  df <- tibble(time = 1:length(bm), position = bm)
  ggplot(df, aes(x = time, y = position)) + 
    geom_line()
}

plot_BM(get_BM(500))
bm1 <- get_BM(500)
plot_BM(bm1)

get_BM(10)[10]
res <- replicate(n = 1000, expr = get_BM(500)[500])
head(res)
hist(res)

bms <- replicate(n = 1000, expr = get_BM(500))
bms[,1]
bms[,2]
bms[,500]
bms[,1000]
hist(bms[400,])

bms_small <- replicate(n = 5, expr = get_BM(10))

# Dice rolls
# roll 3 dice: 1-6 x 3
sample(1:6, 3, replace = TRUE)

roll_dice <- function() {
  sample(1:6, 3, replace = TRUE)
}

# roll 3 dice 1k times and the sum of points
set.seed(42)
dices_sum <- function() {sum(roll_dice())}
dices_sum()
dices_sum

# Aside on great programming practices... (/s)
# mean
# C
# C <- function() {
#   print("Now this is overwriting C. You can't use it anymore. Haha.")
# }
# C()
# 
# ggplot <- function() {
#   print("Now this is overwriting ggplot. You can't use it anymore. Haha.")
# }
# ggplot(data = df)
# ggplot2::ggplot

ggplot <- ggplot2::ggplot
C <- stats::C
hist(replicate(1000, dices_sum()))

df <- tibble(x = replicate(1e5, dices_sum()))
ggplot(df, aes(x)) + geom_histogram()
ggplot(df, aes(x)) + 
  geom_histogram(binwidth = 1, color = "yellow")
ggplot(df, aes(x)) + 
  geom_histogram(bins = 16, color = "yellow")
ggplot(df, aes(x)) + geom_bar()

# Chapter 16 R4DS
# install.packages(lubridate)
library(lubridate)
library(nycflights13)
library(tidyverse)

# Three types of date date related objects
# - Date
# - Time
# - Datetime

today()
now()

ymd("2017-01-03")
mdy("January 31st, 2021")
ymd("2017/01/03")
mdy("1 31st, 2017")

# Dip out toes outside of tidyverse
eng_numbers <- c("one", "two", "three", "four")
hun_numbers <- c("egy", "ketto", "harom", "negy")

eng_numbers[3]
hun_numbers[-1]
hun_numbers[c(2,3,4)]
hun_numbers[c(2, 4)]
hun_numbers[c(F, T, F, T)]
hun_numbers[nchar(hun_numbers) == 5]
he <- tibble(hun = hun_numbers, eng = eng_numbers)
he[2, 1]
he[2, ]
he[5, ] <- c("ot", "five")
he[5, ] <- list(hun = "ot", eng = "five")
he <- select(he, eng, hun)
he[6, ] <- list(hun = "hat", eng = "six")
he <- he[1:5, ]

df_he <- data.frame(hun = hun_numbers, eng = eng_numbers)
df_he[5, ] <- c("ot", "five")
df_he

he[,"eng"]

he[, "eng"]
he[, "hun"]

he$eng
he$eng[3]
he[["eng"]]
lang <- "hun"
he[[lang]]
he[[1]]
he[[2]]

for (i in seq_along(he)) {
  print(he[[i]])
}
