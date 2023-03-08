# Lecture 9

# Chapter 12: Tidy Data
library(tidyverse)

table4a
# afg: One row for 1999, and one for 2000.
# We have to have a table with columns:
# - Country
# - Year
# - Value

# If it was tidy:
# country | year  | numberofcases
# afg       1999    745
# afg       2000    2666 
# ...

stocks <- tibble(
  year = c(2015, 2015, 2016, 2016),
  half = c(1, 2, 1, 2),
  return = c(1.88, 0.59, 0.92, 0.17)
)

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

people %>% 
  pivot_wider(names_from = names, values_from = values)

# ...

# Exercise 4 
# Tidy the tibble. Do you need to make wider or longer?
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)

