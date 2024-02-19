# Lecture 8: Chapter 13 in R4DS

library(tidyverse)
library(nycflights13)

# Joins
planes

# How can we find out if tailnum is a primary key?
planes %>%
  count(tailnum) %>%
  filter(n > 1)

length(unique(planes$tailnum)) == nrow(planes)

# What is a pkey for flights? flight does not identify it uniquely within a day.
flights %>%
  count(year, month, day, flight) %>%
  filter(n > 1)

# Add a primary key
(flights2 <- flights %>%
    mutate(pkey = row_number()) %>%
    select(pkey, everything()))

colnames(airlines)
colnames(flights2)

flights3 <- flights2 %>%
  select(pkey, year:day, hour, origin, dest, carrier, tailnum)

flights3 %>% slice(2)

flights3 %>%
  left_join(airlines, by = "carrier") %>%
  slice(n=2)

x <- tibble("name" = c("m", "lm", "wm"),
            "height" = c(1.19, 1.80, 0.00))
y <- tibble(
  name = c("m", "m", "lm", "bm"),
  class = c("R", "I", "LR", "NC")
)
x
y
left_join(x, y)
right_join(y, x)
right_join(x, y)
inner_join(x, y)
full_join(x, y)

flights2 %>%
  left_join(weather, by = c("year", "month", "day", "hour", "origin"))

# If weather had data on destination airports, could merge like this.
#flights2 %>%
#  left_join(weather, by = c("year", "month", "day", "hour", "dest" = "origin")) %>%
#  select(wind_speed, everything())

# Filtering joins

# To see which rows do have a match, use semi join
flights2 %>%
  semi_join(weather, by = c("year", "month", "day", "hour", "dest" = "origin"))

# Find the top 10 most popular destinations

(top10 <- flights %>%
    count(dest) %>%
    arrange(desc(n)) %>%
    slice(1:10))

# Flights to these top10 destinations
inner_join(flights, top10, by = "dest") # This adds column `n`
left_join(flights, top10, by = "dest") %>%
  filter(!is.na(n)) # Hides what you want and poor performance
semi_join(flights, top10, by = "dest") # Does not add column `n`
flights2 %>%
  filter(dest %in% top10$dest)

# Get the top 11 dest...
(ranked_dest <- flights3 %>%
    group_by(dest) %>%
    summarize(
      n = n()
    ) %>%
  mutate(
    r = min_rank(desc(n))
  ) %>%
  arrange(r))
  
flights %>%
  semi_join(
    filter(ranked_dest, r <= 11)
    )

flights %>%
  filter(dest %in% ranked_dest$dest[1:11])
  
# With multiple fields you really want semi-join
# Get flights on the 10 worst days by arrival delay

(worst_days <- flights %>%
    group_by(year, month, day) %>%
    summarise(
      avg_delay = mean(arr_delay, na.rm = TRUE)
    ) %>%
    # Need to ungroup, because we are still in a state equivalent
    # to group_by(year, month), so that the rank in the muatate
    # is done by year and month grouping
    ungroup() %>%
    mutate(
      rank_delay = rank(desc(avg_delay))
    ) %>%
    arrange(rank_delay))

flights %>%
  inner_join(worst_days %>% filter(rank_delay <= 10))
# Three steps when joining  
# 1. Identify the primary key
# 2. Is the primary key present for all rows?
# 3. Does the key exist in both tables? anti_join to find out

library(magrittr)

flights %>%
  anti_join(planes, by = "tailnum") %>%
  select(carrier) %$%
  unique(carrier)
