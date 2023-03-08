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

# Gathering
(tidy4a <- table4a |>
  pivot_longer(cols = c(`1999`, `2000`), names_to = "Year", values_to = "Cases"))

(tidy4b <- table4b |>
  pivot_longer(cols = c(`1999`, `2000`), names_to = "Year", values_to = "Population"))

(tidy4 <- left_join(tidy4a, tidy4b))
(tidy4a <- tidy4a |> filter(country %in% c("Afghanistan", "Brazil")))
(tidy4 <- left_join(tidy4a, tidy4b))
(tidy4b2 <- table4b |> filter(country %in% c("Afghanistan", "China")))
(tidy4 <- left_join(tidy4a, tidy4b2))

table2 |> 
  pivot_wider(names_from = "type", values_from = "count")


# View(table4a)

(stocks <- tibble(
  year = c(2015, 2015, 2016, 2016),
  half = c(1, 2, 1, 2),
  return = c(1.88, 0.59, 0.92, 0.17)
))

stocks
stocks |> 
  pivot_wider(names_from = year, values_from = return) |>
  pivot_longer(
    cols = c(`2015`, `2016`), 
    names_to = "year", 
    values_to = "return"
    #names_transform = list(year = as.double)
  )

# Exericse 3 in 12.3
# Why does widening this table fail? How could adding an additional column help?
(people <- tribble(
  ~name,             ~names,    ~values,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
))

people %>% 
  pivot_wider(names_from = names, values_from = values)

# ...

# Exercise 4 
# Tidy the tibble. Do you need to make wider or longer?
(preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
))

preg |> 
  pivot_longer(cols = c(male, female), names_to = "gender", values_to = "count")

library(readr)
df <- read_csv("data/some_choices.csv")


## Separate and Unite

table3
(table3sep <- table3 |>
  separate(rate, into = c("cases", "population"), convert = TRUE) |>
  separate(year, into = c("century-1", "year"), sep = 2) |>
  mutate(century = as.integer(`century-1`) + 1) |>
  select(-"century-1"))

table3sep |>
  unite(new, century, year, sep="")

?extract
