# Lecture 8: Chapter 13 in R4DS

library(tidyverse)
library(nycflights13)

# Joins
planes

# How can we find out if tailnum is a primary key?

# What is a pkey for flights? flight does not identify it uniquely within a day.

# Add a primary key


x <- tibble("name" = c("m", "lm", "wm"),
            "height" = c(1.19, 1.80, 0.00))
y <- tibble(
  name = c("m", "m", "lm", "bm"),
  class = c("R", "I", "LR", "NC")
)


# Filtering joins

# To see which rows do have a match, use semi join

# Find the top 10 most popular destinations


# Flights to these top10 destinations


# Get the top 11 dest...
  

# With multiple fields you really want semi-join
# Get flights on the 10 worst days by arrival delay

    # Need to ungroup, because we are still in a state equivalent
    # to group_by(year, month), so that the rank in the muatate
    # is done by year and month grouping

# Three steps when joining  
# 1. Identify the primary key
# 2. Is the primary key present for all rows?
# 3. Does the key exist in both tables? anti_join to find out

