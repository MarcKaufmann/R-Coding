library(tidyverse)
library(nycflights13)

(by_day <- group_by(flights, year, month, day))
summarise(
  by_day,
  delay = mean(dep_delay, na.rm = TRUE)
)
# Plot the relationship between distance of flight and average delay by destination. 
# To plot, first compute the average delay for each destination.
(distance_delay <- flights |>
    group_by(dest) |> 
    summarise(
      avg_delay = mean(arr_delay, na.rm = TRUE),
      distance = mean(distance, na.rm = TRUE),
      N = n()
    )) 
ggplot(
  data = distance_delay, 
  mapping = aes(x = distance, y = avg_delay)
) + 
  geom_point(mapping = aes(size = N), alpha = 0.3) +
  geom_smooth() +
  geom_smooth(aes(weight = N), color = "yellow") +
  geom_smooth(
    data = flights,
    mapping = aes(x = distance, y = arr_delay),
    color = "red"
  )

# Chicago (1000 miles): 10 50 --> 30
# Atlanta (1500 miles): 0 60  --> 30

# Let us drop flights to HNL (Honululu) and destinations with less than 20 flights
delays <- flights |>
  group_by(dest) |> 
  summarise(
    avg_arr_delay = mean(arr_delay, na.rm = TRUE),
    count = n(),
    distance = mean(distance, na.rm = TRUE)
  ) |>
  filter( count > 20, dest != "HNL")

# Compare the piped solution to the following non-piped version
# Ceci n'est pas une pipe!
filter(
  summarise(
    group_by(flights, dest),
    avg_arr_delay = mean(arr_delay, na.rm = TRUE),
    count = n(),
    distance = mean(distance, na.rm = TRUE)
  ),
  count > 20, dest != "HNL"
)
  
# Counts
## Average delay by airplane (identified by tailnum), plot density
## freqpoly

not_missing <- flights |>
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_missing |> 
  group_by(tailnum) |>
  summarise(avg_delay = mean(dep_delay)) |>
  ggplot(mapping = aes(x = avg_delay)) + 
  geom_histogram(binwidth = 10, color = "purple", fill = "yellow")

not_missing |>
  group_by(tailnum) |>
  summarise(
    count = n(),
    avg_delay = mean(arr_delay)
  ) |>
  ggplot(mapping = aes(x = avg_delay, y = count)) + 
  geom_point(alpha = 0.1)

not_missing_planes <- not_missing |>
  group_by(tailnum) |>
  summarise(
    count = n(),
    mean_delay = mean(arr_delay),
    median_delay = median(arr_delay)
  )

ggplot(data = not_missing_planes) + 
  geom_histogram(mapping = aes(x = median_delay)) +
  geom_histogram(
    mapping = aes(x = mean_delay),
    color = 'yellow',
    alpha = 0.3
  )

# Summary functions

x <- 1:100
x
y <- c(1:100, 46000000000)


mean(x)
mean(y)
median(x)
median(y)
sd(x)
sd(y)
IQR(x)
IQR(y)
mad(x)
mad(y)
min(x)
max(x)

?quantile
quantile(x, 0.25)
quantile(x, 0.50)
median(x)

not_missing
summary(flights)

not_missing |>
  group_by(dest) |>
  summarise(
    count = n()
  )

not_missing |>
  count(dest)

not_missing |>
  group_by(dest) |>
  summarise(
    carriers = n_distinct(carrier)
  )

?count
# How many airmiles a given airplane did (from NYC)
not_missing |>
  count(tailnum, wt = distance) |>
  arrange(desc(n))

# Number of flights each day before 5am
not_missing |> 
  filter(dep_time < 500) |>
  count(year, month, day)

not_missing |>
  summarise(
    group_by(year, month, day),
    sum(dep_time < 500)
  )
