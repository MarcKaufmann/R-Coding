# Last time: group_by(), summarise(), count()

# Ungrouping
library(nycflights13)
library(dplyr)
daily <- flights |>
  group_by(year, month, day)

(daily_flight_count <- summarise(daily, N = n()))
(monthly_count <- summarise(daily_flight_count, N = n()))
(monthly_flight_count <- summarise(daily_flight_count, M = sum(N)))
(yearly_flight_count <- summarise(monthly_flight_count, T = sum(M)))

daily_inverted <- flights |>
  group_by(day, month, year)
daily_inverted |> summarise(N = n()) |> summarise(M = sum(N))
summarise(flights, N = n())
summarise(daily_flight_count, n()) |>
  select('n()')

# To get rid of this remaining grouping, use ungroup
daily2 <- flights |> 
  group_by(year, month, day)

daily |> 
  ungroup() |>
  summarise(N = n())

daily2 |>
  summarise(N = n())

# grouped mutates and filters
flights_small <- flights |> 
  select(year:day, starts_with("arr"), starts_with("dep"))

# Get 10 worst arrivers for every day

# First step: Get 10 worst arrivers in total
flights_small |>
  mutate(delay_rank = rank(desc(arr_delay))) |>
  filter(delay_rank < 11) 
  
# Now get 10 worst arrivers for every day
flights_small |>
  group_by(year, month, day) |>
  mutate(delay_rank = row_number(desc(arr_delay))) |>
  filter(delay_rank < 11)

library(ggplot2)
?diamonds

diamonds |> 
  ggplot(mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.5)

# `cut_width` allows you to bin continuous data
diamonds |>
  mutate(interval = cut_width(carat, 0.5)) |>
  group_by(interval) |>
  summarise(N = n())

# Shorter code for the same thing
diamonds |>
  count(cut_width(carat, 0.5))

x <- 1:10
ifelse(x %% 2 == 0, 'even', 'odd')
case_when(
  x %% 3 == 0 ~ 'divisible by 3', 
  x %% 3 == 1 ~ '+1',
  x %% 3 == 2 ~ '-1'
)

ggplot(diamonds) + 
  geom_histogram(aes( x = y ), binwidth = 0.5) + 
  coord_cartesian(ylim = c(0, 100))
  
diamonds2 <- diamonds |> 
  mutate(y = ifelse( y < 3 | y > 20, NA, y))

ggplot(data = mpg, 
       mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()

ggplot(
  data = mpg, 
  mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)
  ) + 
  geom_boxplot()

ggplot(
  data = mpg, 
  mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)
  ) + 
  geom_boxplot() + 
  coord_flip()
