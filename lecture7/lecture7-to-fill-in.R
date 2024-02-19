library(tidyverse)

# 12.3.1 Gathering

table4a # This is defined 


# We will see more on joins in the coming weeks



# Define stocks
stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)


# Exercise 12.3 the second
# Why does this code fail?

table4a |> 
  pivot_longer(cols = c(1999, 2000), names_to = "year", values_to = "cases")

# Exericse 3 in 12.3
# Why does widening this table fail? How could adding an additional column help?
people <- tribble(
  ~name,             ~names,    ~values,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)

people |>
  pivot_wider(names_from = names, values_from = values)


# Exercise 4 
# Tidy the tibble. Do you need to pivot long or wide?
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)

## Separate and Unite: One column <-> many columns
table3


## Small Test 

# Test if answers to questions are different or not: 
# People answered 6 different questions, wtatest, wta{1,2,3,4,5}. 
# Test, with t.tests, whether the mean answers to these questions are different. 

df <- read_csv("some_choices.csv")

# Let's spread by question_name
df2 <- df |>
  ...
df3 <- df2 |>
  # Keep only those that have no missing values for any answer
  ...

# Or cleaner
df4 <- df2 |>
  ...

# Did it work?
identical(df3, df4)

# However
identical(arrange(df3, desc(playerNr)), df4)

library(magrittr)

# Or, to introduce some loops

# If we want to store t-tests:

# Plot it
library(ggplot2)

## 12.6 Case Study with WHO



# All together now
