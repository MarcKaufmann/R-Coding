# Lecture 8

# Compute for every day how many minutes above average (departure) delay a given 
# flight is

library(nycflights13)
library(dplyr)
flights |>
  group_by(year, month, day) |> 
  mutate(avg = mean(dep_delay, na.rm = TRUE)) |> 
  mutate(diff_from_avg = dep_delay - avg) |>
  select(diff_from_avg, everything())
  # mutate(difference_from_daily_mean_dep_delay = dep_delay - mean(dep_delay, na.rm = TRUE)) |>
  # select(difference_from_daily_mean_dep_delay, everything())

# Ceci n'est pas a tibble

library(tidyverse)
not_tibble <- iris
is_tibble(not_tibble)
a_tibble <- as_tibble(not_tibble)
a_tibble

# How can we call a function on a column at the end of a pipe?
df <- tibble(
  x = runif(100),
  y = runif(100, min = -0.5, max = 0.5),
  z = rnorm(100)
)

t.test(df[["x"]])
df |> select(x) |> t.test()

library(magrittr)
t.test(df$x, df$y) 
df %$% t.test(x, y)

# Chapter 11: Data Import

(test_data1 <- read_csv("lecture6/test-data.csv"))

read_csv(
  "dfjdksfjdlkfsjdlkjf
  a,b,c
  1,2,3
  4,5,6",
  skip = 1
)

read_csv(
  "1,2,3
  4,5,6",
  col_names = c("First", "Second", "Third")
)

read_csv(
  "1,2,3
  4,.,6",
  col_names=c("First", "Second", "Third"),
  na = "."
)

?read_csv
?read_delim
?read_tsv
?read_csv2

# Class Exercise 5 in 11.2
# IDentify what is wrong with each of 

# "\n" is the newline character in many programming
read_csv("a,b
         1,2,3
         4,5,6")
read_csv("a,b,c,d
         1,2
         1,2,3,4")
read_csv("a,b\n\"1")
read_csv("Marc,Yigit\n1,2\nMarc,Yigit\n1,2\nMarc,Yigit")
read_delim("a;b\n1;3", delim = ";")
read_csv2("a;b\n1;3")

# 11.3 Parsing a vector

str(parse_logical(c("TRUE", "FALSE", "NA", "F", "T")))
str(parse_integer(c("1", "2", "310", "2.3")))
str(parse_date(c("2010-10-01", "1974-01-14")))
str(parse_double(c("1", "2", "310", "2.3")))
str(parse_number("$100 is not a lot but $200 is"))

# When reading in data, be specific on the column types
df1 <- read_csv(
  "lecture7/test-data1.csv", 
  col_names = F,
  col_types = "iiicl"
)
df1
