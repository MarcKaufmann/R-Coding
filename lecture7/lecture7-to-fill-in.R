library(tidyverse)

# 12.3.1 pivot-longer

table4a # This is defined 
?table4a
# country | year | cases 
# afg    | 1999 | 745
# afg    | 2000 | 2666
# ...
# as.character(2000:2010)
(tidy4a <- table4a |>
  pivot_longer(cols = c("1999", "2000"), names_to = "Year", values_to = "Cases"))

table4b
(tidy4b <- table4b |>
  pivot_longer(
    cols = c("1999", "2000"), 
    names_to = "Year", 
    values_to = "Population"
  ) |>
  mutate(Year = as.integer(Year)))

# We will see more on joins in the coming weeks
(tidy4 <- left_join(tidy4a, tidy4b))



# Define stocks
stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)

stocks |>
  pivot_wider(names_from = year, values_from = return) |>
  pivot_longer(
    cols = c("2015", "2016"), 
    names_to = "year", 
    values_to = "return",
    names_transform = list(year = as.double)
  )
  
stocks

# Exercise 12.3 the second
# Why does this code fail?

table4a |> 
  pivot_longer(cols = c("1999", "2000"), names_to = "year", values_to = "cases")

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

# 1. What are the columns I want at the end?
# pregnant, sex, count
# 2. Where does the data for each column come (cols = ...) from 
#    and then go to (names_to = ..., values_to = ...)?

preg |>
  pivot_longer(cols = c("male", "female"), names_to = "sex", values_to = "count")

## Separate and Unite: One column <-> many columns
table3
(table3sep <- table3 |>
  separate(rate, into = c("cases", "population"), convert = TRUE))

table3sep |>
  unite(new, cases, population, sep="/")


## Small Test 

# Test if answers to questions are different or not: 
# People answered 6 different questions, wtatest, wta{1,2,3,4,5}. 
# Test, with t.tests, whether the mean answers to these questions are different. 

df <- read_csv("lecture7/some_choices.csv")
df


# Let's pivot_wider by question_name
df2 <- df |>
  pivot_wider(names_from = question_name, values_from = answer)

is_not_na <- function(x) {
  !is.na(x) 
}

df2[1,2] <- NA
df2
df3 <- df2 |>
  # Keep only those that have no missing values for any answer
  #filter(!is.na(wtatest), !is.na(wta1), ...)
  filter( if_all(starts_with("wta"), is_not_na) )

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
