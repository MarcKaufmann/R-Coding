# Lecture 10

# Based on R skills by Gergo Daroczi, lectures 1 and 2

# Plot Brownian Motions (BMs)

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

# Another example: simulating dice rolls

## roll 3 dices! 1-6 x 3
sample(1:6, 3, replace = TRUE)

## TODO roll 3 dices 1K times and plot the sum of points
set.seed(42)
dices <- function() {sample(1:6, 3, replace = TRUE)}
dices_sum <- function() {sum(dices())}
dices_sum()
hist(replicate(1000, dices_sum()))
## NOTE shouldn't this be symmetric?

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

# =========================================================
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
# Lesson: Do *not* put ggplot in a for loop if you want multiple graphs on the same plot.
# Use ggplot functionality to create multiple plots directly (i.e. pass a dataframe with all the
# data, and group correctly).
# Bugs will ensue.
# =========================================================

# Chapter 16

library(tidyverse)
library(lubridate)
library(nycflights13)

# Three types of objects (as for SQL):
# - Date
# - Time
# - Date-Time

# Dates and times are tricky. See this Java question on times, and the answer.
# https://stackoverflow.com/questions/6841333/why-is-subtracting-these-two-times-in-1927-giving-a-strange-result

# If you need to work with times only (without date), you need the hms package 

today()
now()

# Parsing dates from strings/input

# How to read in dates (besides parse_date and parse_datetime)
ymd("2017-01-31")
mdy("January 31st, 2017")
dmy("31-Jan-2017")

# Notice: the precise formatting doesn't matter
ymd("2017/01/31")
ymd("2017-01-31")
ymd(20170131)

# The same logic extends to date-times:
ymd_hms("2017-01-31 20:11:59")
mdy_hm("01/31/2017 08:01")

# Making dates from bits
flights %>%
  select(year, month, day, hour, minute) %>%
  mutate(departure = make_datetime(year, month, day, hour, minute)) %>%
  mutate(departure_date = make_date(year, month, day))

# Class exercise

make_datetime_100 <- function(year, month, day, time) {
  make_datetime(...)
}

flights_dt <- flights %>%
  filter(!is.na(dep_time), !is.na(arr_time)) %>%
  mutate(
    dep_time = ...,
    arr_time = ...,
    sched_dep_time = ...,
    sched_arr_time = ...
  ) %>%
  select(origin, dest, ends_with("delay"), ends_with("time"))

flights_dt %>%
  ggplot(aes(x = dep_time)) +
  geom_freqpoly(binwidth = 3600*24*7)

flights_dt %>%
  filter(dep_time < ymd(20130102)) %>%
  ggplot(aes(x = dep_time)) + 
  geom_freqpoly(binwidth = 900)

# `as_date()` turns a date-time into a date object, so you can filter on date
flights_dt %>%
  filter(as_date(dep_time) == ymd(20130102)) %>%
  ggplot(aes(x = dep_time)) + 
  geom_freqpoly(binwidth = 900)

today(tzone = "Asia/Tokyo")
today(tzone = "Asia/Shanghai")
today(tzone = "America/Los_Angeles")

# Getting parts of a date-time
year(today())
month(today())
month(today(), label = TRUE)
day(today())
mday(today())
yday(today())
wday(today())
wday(today(), label = TRUE)

# Get number of flights by weekday
flights_dt %>%
  mutate(wday = wday(dep_time, label = TRUE)) %>%
  ggplot(aes(x = wday)) + 
  geom_bar()

floor_date(today(), "week")
floor_date(ymd(20191112), "week")
?floor_date

flights_dt %>%
  count(week = floor_date(dep_time, "week")) %>%
  ggplot(aes(week, n)) +
  geom_line()

# A good reason not to use geom_freqpoly() and to directly plot what you measured:
flights_dt %>%
  mutate(week = floor_date(dep_time, "week")) %>%
  ggplot(aes(week)) +
  #ggplot(aes(dep_time)) +
  # Wow, that's one hell of weird effect...
  # geom_freqpoly(bins = ...) +
  geom_freqpoly(bins = 52)

(datetime <- ymd_hms("2016-07-08 12:34:56"))
update(datetime, year = 2020, month = 13)
update(today(), hours = 36)

# Distribution of flights by time of day

flights_dt %>%
  mutate(time_of_day = update(dep_time, yday = 1)) %>%
  ggplot(aes(time_of_day)) + 
  geom_freqpoly(bins=24*10)

# Why do we set the day to yday = 1? Why not just use time?

# Class exercise: 
# Write a function to compute the age of a person in days, given their birthdate

age_in_days <- function(d) (today() - d)
age_in_days(ymd(20121104))

# When adding and subtracting, it's best to use durations
# d* functions return durations, which is always in seconds
dseconds(15)
dminutes(15)
dminutes(15) + ddays(2)

seconds(15)
minutes(15)
minutes(15) + days(2)
months(c(1,3))

today() + years(1)
ymd(20110615) + months(2)

# Dipping our toes outside the tidyverse

# socviz.co, Appendix on "The basics of accessing and selecting things"

eng_numbers <- c("one", "two", "three", "four")
hun_numbers <- c("egy", "ketto", "harom", "negy")

eng_numbers[3]
hun_numbers[3]
hun_numbers[7]
hun_numbers[-1]
hun_numbers[2:4]
eng_numbers[c(2,3,4)]
eng_numbers[c(2,4)]
eng_numbers[c(4,2)]
he <- tibble(hun = hun_numbers, eng = eng_numbers)
he[2, 1]
he[2, 2]
he[2, ]
he[, 2]
he[, 1]
he[, "eng"]
he[, eng]
he[3, "eng"]
he[3, ]

he$eng
he$eng[3]

df <- tibble(x = c(1,2,3), y = 2*x + rnorm(3))
fit <-lm(y ~ x, df)
str(fit)
fit$coefficients
fit$coefficients[2]
str(fit$coefficients)
fit$call
fit$qr$rank
df$z <- df$x^2 + 5*rnorm(3)
df

df[[1]]
df$x
df[[2]]
df$y

for (i in seq_along(df)) {
  print(df[[i]])
}
