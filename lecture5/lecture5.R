# Script for lecture 5

# Team 4
# Péter
# Alexandra
# Kristof
# Miklos

# Points:
# 1. Don't list all functions, e.g. geoms
# 2. Exam in DA1
# 3. Look at file before submitting
# 4. ggsave
# 5. using vienna code and theming
# 6. Team: How to assign/report exercises
# 7. After week 6, change of time (17:30-19:00), same room

# Today: group_by(), summarise()
# Next week(s): read_*, parse_*, spread() and gather() tidy the data

# Summary functions

(x <- 1:100)
median(x)
mean(x)
sd(x)
IQR(x)
mad(x)
?mad
min(x)
max(x)

# when using mean, consider median
mean(x)
median(x)
x_with_outlier <- c(x, 1000000000)
mean(x_with_outlier)
median(x_with_outlier)

# What is quantile?
?quantile

quantile(x, 0.20)
quantile(x, 0.80)

z <- c(0, 0, 0, 0, 0, 1, 2, 100, 100)
quantile(z, 0.50)
quantile(z, 0.90)
quantile(z, 0.40)

# Counts

library(nycflights13)
library(tidyverse)

not_missing <- flights %>%
  filter(
    !is.na(arr_time), 
    !is.na(dep_time),
    !is.na(arr_delay),
    !is.na(dep_delay)
    )

# Count the number of flights to each destination

not_missing %>%
  group_by(dest) %>%
  summarise(
    n = n()
  )
  
# Short hand
not_missing %>%
  count(dest)

# Count the number of distinct carriers to each location
not_missing %>%
  group_by(dest) %>%
  summarise(
    carriers = n_distinct(carrier)
  ) %>%
  arrange(desc(carriers))

# You can weight the counts
# Count the airmiles a given airplane does from NYC
not_missing %>%
  count(tailnum, wt = distance) %>%
  arrange(desc(n))

# Number of flights each day before 5am
not_missing %>%
  group_by(year, month, day) %>%
  summarise(before_5am = sum(dep_time > 2400))
  #filter( dep_time > 2400) %>%
  #summarise(count = n())

# If you have to get rid of group_by, use ungroup

daily <- flights %>%
  group_by(year, month, day)

summarise(daily, n())

daily %>%
  ungroup() %>%
  summarise(n())

# 5.7. Grouped Mutates

# Get the worst 10 arrivers for every day
# Worst: arr_delay is highest
flights_small <- flights %>%
  select(year:day, starts_with("arr"), starts_with("dep"))

flights_small %>%
  group_by(year, month, day) %>%
  mutate(delay_rank = rank(desc(arr_delay))) %>%
  filter(delay_rank <= 2)

# Find flights to destinations that have more than one flight 
# arriving/going on average per day
(popular_destinations <- flights %>%
  group_by(dest) %>%
  filter(n() > 365))

# Chapter 7

# cut_width()

diamonds %>%
  ggplot(mapping = aes(x = carat)) + 
  geom_histogram(binwidth = 0.5)

# histogram uses cut_width() to create these bins

diamonds %>%
  mutate(interval = cut_width(carat, 0.5)) %>%
  count(interval)

# ifelse()

x <- 1:10
ifelse(x %% 2 == 0, 'even', 'odd')

# case_when
?case_when
case_when(
  x %% 3 == 0 ~ "divisible by 3",
  x %% 3 == 1 ~ "+1",
  x %% 3 == 2 ~ "-1"
)

diamonds2 <- diamonds %>%
  mutate(y = ifelse(y < 3 | y > 20, NA, y))

