# Lecture 8: Chapter 13 in R4DS

library(tidyverse)
library(nycflights13)

# Joins
planes

# How can we find out if tailnum is a primary key?
stopifnot(length(unique(planes$tailnum)) == length(planes$tailnum))
planes |>
  count(tailnum) |>
  filter(n > 1)

# What is a pkey for flights? flight does not identify it uniquely within a day.
flights |>
  count(year, month, day, flight) |>
  filter(n > 1)

# Add a primary key
(flights2 <- flights |>
    mutate(pkey = row_number()) |>
    select(pkey, everything()) )

# Ready to join
colnames(airlines)
colnames(flights2)

flights3 <- flights2 |>
  select(pkey, year:day, hour, origin, dest, carrier, tailnum)

slice(flights, 2)

left_join(flights3, airlines, by = "carrier")

x <- tibble("name" = c("m", "lm", "wm"),
            "height" = c(1.19, 1.80, 0.00))
y <- tibble(
  name = c("m", "m", "lm", "bm"),
  class = c("R", "I", "LR", "NC")
)

left_join(x,y)
right_join(y, x)
inner_join(x, y)
full_join(x, y)
semi_join(x, y)

x <- c(0, 1)

# Filtering joins

weather
# To see which rows do have a match, use semi join
flights2 |>
  semi_join(weather, by = c("year", "month", "day", "hour"))

# Find the top 10 most popular destinations
(top10 <- flights |> 
  count(dest) |>
  arrange(desc(n)) |>
  slice(1:10))


# Flights to these top10 destinations
semi_join(flights, top10, by = "dest")
flights2 |>
  filter(dest %in% top10$dest)

# Get the top 11 dest...
ranked_dest <- flights3 |>
  count(dest) |>
  mutate( 
    r = min_rank(desc(n))
  )

top11 <- flights3 |>
  semi_join(
    filter(ranked_dest, r <= 11)
  )

top_n <- function(df, m) {
  df |>
    semi_join(
      filter(ranked_dest, r <= m)
    )
}

top_n2 <- function(df, m) {
  topM <- filter(ranked_dest, r <= m)
  df |>
    filter( dest %in% topM$dest )
}

identical(top_n2(flights3, 11), top11)
  

# With multiple fields you really want semi-join
# Get flights on the 10 worst days by arrival delay

    # Need to ungroup, because we are still in a state equivalent
    # to group_by(year, month), so that the rank in the muatate
    # is done by year and month grouping

# Three steps when joining  
# 1. Identify the primary key
# 2. Is the primary key present for all rows?
# 3. Does the key exist in both tables? anti_join to find out

