# Lecture 7

# Chapter 12: Tidy Data
library(tidyverse)

table4a
# Afg: One row for 1999, and one for 2000.
# We have to have a table with columns:
# - Country
# - Year
# - Value

# If it was tidy:
# country | year  | numberofcases
# afg       1999    745
# afg       2000    2666 
# ...

my_table <- table4a
my_table <- my_table %>%
  mutate(continent = c("Asia", "South America", "Asia"))
my_table

tidy4a <- table4a %>%
  pivot_longer(cols = c(`1999`, `2000`), names_to = "Year", values_to = "Cases")

tidy4b <- table4b %>%
  pivot_longer(cols = c(`1999`, `2000`), names_to = "Year", values_to = "Population")

tidy4 <- left_join(tidy4a, tidy4b) 
tidy4 %>%
  mutate(freq = Cases / Population)

table2 %>%
  pivot_wider(names_from = type, values_from = count)

table2 %>%
  slice(1:5) %>%
  pivot_wider(names_from = type, values_from = count)

stocks <- tibble(
  year = c(2015, 2015, 2016, 2016),
  half = c(1, 2, 1, 2),
  return = c(1.88, 0.59, 0.92, 0.17)
)

stocks %>%
  pivot_wider(names_from = year, values_from = return) %>%
  pivot_longer(cols = c(`2015`, `2016`), names_to = "year", values_to = "return")

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

# Add year when information was added or similar

# Exercise 4 
# Tidy the tibble. Do you need to make wider or longer?
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)

table3sep <- table3 %>%
  separate(rate, into = c("cases", "population"), convert = TRUE) %>% 
  separate(year, into = c("century", "year"), sep = 2)

# To reverse:
table3sep %>%
  unite(year, century, year, sep="")

df <- read_csv("some_choices.csv")
unique(df$question_name)

df2 <- df %>%
  pivot_wider(names_from = "question_name", values_from = "answer")

df3 <- df2 %>%
  # Keep only those that have no missing values for any answer
  filter(!is.na(wtatest), !is.na(wta1), !is.na(wta2), !is.na(wta3), !is.na(wta4), !is.na(wta5))

is_not_na <- function(x) {
  !is.na(x)
}

df4 <- df2 %>%
  filter(across(starts_with("wta"), is_not_na))

df3 == df4
identical(df3, df4)
identical(df3, arrange(df4, desc(playerNr)))
stopifnot(length(union(df3, df4)) == length(intersect(df3, df4)))

library(magrittr)

df3 %$% t.test(wta1, wta2)
df3 %$% t.test(wta1, wta3)
df3 %$% t.test(wta1, wta4)
df3 %$% t.test(wta1, wta5)

for (otherwta in c("wta2", "wta3", "wta4", "wta5")) {
  print(t.test(df3$wta1, df3[[otherwta]]))
}

lottests <- df3 %$% list(
  "1v2" = t.test(wta1, wta2),
  "1v3" = t.test(wta1, wta3),
  "1v4" = t.test(wta1, wta4),
  "1v5" = t.test(wta1, wta5)
)

# More code ...

# What should the table look like after spreading:
# - Country
# - Year
# - cases
# - population

# Spread table2

# Stocks
stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)

# spread this so there is one observation per year
# key = "half", 

# separate table 3

# unite again
table3sep %>%
  ...

# Small Test

