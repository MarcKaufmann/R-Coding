# Lecture 7

# reading in test data
library(tidyverse)
df1 <- read_csv("test-data1.csv", col_names = FALSE)
# df1 <- read_csv("test-data1.csv", col_names = FALSE, col_types = "ccccc")
df1

df2 <- read_csv("test-data2.csv", na = c("."))
df2

(df3 <- read_csv("test-data3.csv"))
head(df3)
tail(df3)
head(read_csv("test-data3.csv", col_types = "ccccc"))
tail(read_csv("test-data3.csv", col_types = "nnccc"))

# When there are problems:
# 1. RTWM: Read the error/warning message
# 2. problems(df3) or use `tail()` to look at the problematic rows
# 3. Read in as characters, via col_types = "ccccc..."
# 4. And then fix one column at a time


# Chapter 12: Tidy Data

table4a
# Afg: One row for 1999, and one for 2000.
# We have to have a table with columns:
# - Country
# - Year
# - Value

tidy4a <- table4a %>%
  gather(key = "year", value = "value", `1999`, `2000`)
tidy4a

table4ab <- table4a
table4ab <- table4ab %>% mutate(continent = c("Asia", "Latin America", "Asia"))
table4ab %>%
  gather(key = "year", value = "cases", `1999`, `2000`)

tidy4b <- table4b %>%
  gather(key = "year", value = "population", `1999`, `2000`)

tidy4b
tidy4a

tidy4 <- left_join(tidy4a, tidy4b)
tidy4

# What should the table look like after spreading:
# - Country
# - Year
# - cases
# - population
tidy2 <- table2 %>%
  spread(key = "type", value = "count")
tidy2

stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)

# spread this so there is one observation per year
# key = "half", 
stocks %>%
  spread(key = half, value = return) %>%
  rename(first_half = `1`, second_half = `2`)

# separate and unite

(table3sep <- table3 %>%
  separate(rate, into = c("cases", "population"), convert = TRUE) %>%
  separate(year, into = c("century", "year"), sep = 2))
  
# unite
table3sep %>%
  unite(new, century, year, sep="////")

# Small Test

(df <- read_csv("some_choices.csv"))
unique(df$question_name)

# Let's do a t-test to check if the aveage value for 
# wta1 is different from that of other answers.

df2 <- df %>%
  spread(key = question_name, value = answer) %>%
  # filter(!is.na(wtatest), !is.na(wta1), !is.na(wta2), !is.na(wta3), !is.na(wta4), !is.na(wta5))
  # Or better:
  filter_all(all_vars(!is.na(.)))

library(magrittr)
df2 %$% t.test(wta1, wta2)
df2 %$% t.test(wta1, wta3)
df2 %$% t.test(wta1, wta4)
