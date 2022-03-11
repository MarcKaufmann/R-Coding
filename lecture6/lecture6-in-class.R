# Lecture 6
# Bug
# Questions?
# If you hit error on website: "Error..."
# You might get message "Sorry, your session expired"

library(tidyverse)
library(nycflights13)
# Compute for every day how many minutes above the average delay a given flight is.
# 1. Grouping
# 2. Average delay per day
# 3. Diff between average in step 2 and actual delay
flights_small <- flights %>%
  select(year, month, day, starts_with("arr"), starts_with("dep"))

flights_small %>%
  group_by(year, month, day) %>%
  mutate(
    mean_delay = mean(dep_delay, na.rm = TRUE), 
    above_mean_delay = dep_delay - mean_delay
  )

# Compute how many std dev a flight is from the mean (that day).
# Relevant quantities: mean; std dev; diff_from_the_mean; ?? std_dev_diff_from_the_mean 
# mean, sd, dep_delay - mean => diff_from_the_mean; diff_from_the_mean / sd
flights_small %>%
  group_by(year, month, day) %>%
  mutate(
    sd_delay = sd(dep_delay, na.rm = TRUE),
    diff_from_mean = dep_delay - mean(dep_delay, na.rm = TRUE),
    diff_from_mean_in_sd = diff_from_mean / sd_delay
  ) 

# Exercise: What time of the day should you fly to avoid delays? 

df <- tibble(
  x = runif(100),
  y = runif(100, min = -0.5, max = 0.5),
  z = rnorm(100)
)

t.test(df$x)
t.test(df[["x"]])
t.test(select(df, x))
t.test(df$x, df$y)
t.test(select(df, x, y)) 
t.test(df)

df %>% .$x %>% t.test()

library(magrittr)
df %$% t.test(x, y)
t.test(df$x, df$y)

# Not everything is a tibble
iris
ceci_nest_pas_a_tibble <- iris
is_tibble(ceci_nest_pas_a_tibble)
iris
a_tibble <- as_tibble(ceci_nest_pas_a_tibble)
a_tibble

# Chapter 11

(test_data1 <- read_csv("test-data.csv"))
# Now I added a pointless line at the top of the test-data.csv
(test_data1_again <- read_csv("test-data.csv", skip = 1))
read_csv(
  "1,2,3
  4,5,6",
  col_names = c("realname1", "y", "z")
)

read_csv(
  "1,2,3
  4, ., 6",
  col_names = FALSE,
  na = c(".", "", "NA"))

?read_delim
?read_tsv
# Use read_csv2 if the separator is a semicolon (;)
read_csv("a,b\n1,2,3\n4,5,6")
read_csv("a,b\n\"1")

# To fix, you might need to do some parsing
str(parse_logical(c("TRUE", "FALSE", "NA")))
parse_integer(c("1", "2", "3"))
# Note to self: WHAT???
"1" == 1
"TRUE" == TRUE

str(parse_date(c("2010-10-01", "1974-01-14")))
parse_integer(c("123", "abc", "12.3"))
parse_number(c("12.3"))
parse_number(c("12.3", "$100,200"))

challenge <- read_csv(readr_example("challenge.csv"))
