# git
# knit at the end of class (final 15 minutes)
# bug

# Start with end of Lecture 4: line 225

# 5.6.2 Missing Values
library(nycflights13)
library(tidyverse)

not_missing <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))

filter(flights, !is.na(dep_delay))

# Counts
# Avg delay by airplane (tailnum), plot density

not_missing %>%
  group_by(tailnum) %>%
  summarise(avg_delay = mean(dep_delay)) %>%
  ggplot(mapping = aes(x = avg_delay)) + 
  geom_histogram(binwidth = 10)
  
# Plot number of flights per airplane against delay
not_missing %>%
  group_by(tailnum) %>%
  summarise(
    count = n(),
    avg_delay = mean(arr_delay)
  ) %>%
  ggplot(mapping = aes(x = avg_delay, y = count)) + 
  geom_point(alpha = 0.1)

not_missing_planes <- not_missing %>%
  group_by(tailnum) %>%
  summarise(
    count = n(),
    mean_delay = mean(arr_delay),
    median_delay = median(arr_delay)
  )

# Get the median delay for each airplane
ggplot(data = not_missing_planes) + 
  geom_histogram(mapping = aes(x = median_delay)) +
  geom_histogram(mapping = aes(x = mean_delay), color = 'yellow', alpha = 0.3)

not_missing_planes %>%
  filter(count > 10) %>%
  ggplot(mapping = aes(x = mean_delay)) + 
  geom_histogram(binwidth = 5)

# Lecture 5

# Some summary functions
x <- 1:100
median(x)
sd(x)
IQR(x)
iqr(x)
mad(x)
?mad
min(x)
max(x)
?IQR
abs(-3 )

x_with_outlier <- c(x, 100000000000)
mean(x_with_outlier)
median(x_with_outlier)

?quantile

quantile(x, 0.25)
quantile(x, 0.20)
y <- rep(0, 50)
y <- c(y, 1, rep(100, 50))
y
median(y)
x
median(x)
mean(y)
mean(x)
y
x <- c(x, 101)
z <- x + y
z
mean(z)
median(z)

# Counting

# Count the number of flights by destination
not_missing %>%
  group_by(dest) %>%
  summarise(
    count = n()
  )

not_missing %>%
  group_by(dest) %>%
  summarise(
    carriers = n_distinct(carrier)
  )

# equivalent to group_by(dest) followed by summarise(n())
not_missing %>%
  count(dest)

# Count airmiles a given airplane did from NYC
# tailnum, distance
not_missing %>%
  count(tailnum, wt = distance) %>%
  arrange(desc(n))

# Number of flights each day (date) before 5am
not_missing %>%
  group_by(year, month, day) %>%
  summarise(
    before_5am = sum(dep_time < 500)
  )

# What proportion of flights is delayed each day by more than 1 hour?
not_missing %>%
  group_by(year, month, day) %>%
  summarise(
    more_than_one_hour = mean(arr_delay > 60)
  )
  
# Ungroup

daily <- flights %>%
  group_by(year, month, day)

daily2 <- flights %>%
  group_by(year, month, day)

daily %>% 
  ungroup() %>%
  summarise(n())

daily2 %>%
  summarise(n())

# 5.7 Grouped mutates

# Get the worst 10 arrivers for every day
flights_small <- flights %>%
  select(year, month, day, starts_with("arr"), starts_with("dep"))

flights_small %>%
  group_by(year, month, day) %>%
  mutate(delay_rank = rank(desc(arr_delay))) %>%
  filter(delay_rank < 5) %>%
  arrange(year, month, day, delay_rank)
