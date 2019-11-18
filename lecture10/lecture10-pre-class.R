# Lecture 10

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

#make_datetime_100 <- function(year, month, day, time) {
#  make_datetime(year, month, day, time %/% 100, time %% 100)
#}

#flights_dt <- flights %>%
#  filter(!is.na(dep_time), !is.na(arr_time)) %>%
#  mutate(
#    dep_time = make_datetime_100(year, month, day, dep_time),
#    arr_time = make_datetime_100(year, month, day, arr_time),
#    sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
#    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
#  )  %>%
#  select(origin, dest, ends_with("delay"), ends_with("time"))

#flights_dt

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
  # geom_freqpoly(bins = 52) +
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
