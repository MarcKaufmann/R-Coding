# Lecture 6 script

# 1. Notes on Assignment 3
# 2. No assignment next week
# 3. Team presentation
# 4. Record OBS

# This week: how to read in data
# Next week: how to join data
# From then on, explore various topics (and non-tidyverse)

# Ceci n'est pas a tibble

library(tidyverse)

ceci_nest_pas_a_tibble <- iris
is_tibble(ceci_nest_pas_a_tibble)
ceci_nest_pas_a_tibble
a_tibble <- as_tibble(ceci_nest_pas_a_tibble)
a_tibble

t.test(a_tibble$Sepal.Length)

df <- tibble(
  x = runif(100),
  y = runif(100, min=-0.5, max=0.5), 
  z = rnorm(100)
)

t.test(df$x, df$y)

df %>% select(x)
df %>% .$x
df %>% t.test(.$x)
df %>% .$x %>% t.test()

df2 <- df
t.test(df2$x)

library(magrittr)
df %$% t.test(x,y)
df %$% cor(x,y)

# Chapter 11: Data Import

(test_data1 <- read_csv("lecture6/test-data.csv"))

read_csv(
  "dfjdksfjdlkfsjdlkjf
  a,b,c
  1,2,3
  4,5,6",
  skip = 1)
)

read_csv(
  "1,2,3
  4,.,6",
  col_names=c("First", "Second", "Third"),
  na = ".")

?read_delim
?read_tsv
?read_csv2

# Class Exercise 5 in 11.2
# IDentify what is wrong with each of 

# "\n" is the newline character in many programming
read_csv("a,b,c
         1,2,3
         4,5,6")
read_csv("a,b,c,d
         1,2
         1,2,3,4")
read_csv("a,b\n\"1")
read_csv("a,b\n1,2\na,b\n1,2\na,b", col_names=FALSE)
read_csv2("a;b\n1;3")

# 11.3 Parsing

read_csv

parse_logical(c("TRUE", "FALSE", "NA"))
parse_logical(c("TRUE", "FALSE", "NA"))
# -> c(TRUE, FALSE, NA)
parse_integer(c("1", "10", "3"))
parse_character(c("TRUE"))
parse_date(c("2010-10-01"))
x <- parse_integer(c("123", "234", "abc", "12.3"))
x
problems(x)
parse_double("12.3")
parse_number(c("$100", "NA"))

# 11.4 

challenge <- read_csv(readr_example("challenge.csv"))
problems(challenge)

challenge2 <- read_csv(readr_example("challenge.csv"), col_types = cols(
  x = col_character(),
  y = col_character()
))

tail(challenge2)
challenge2 <- read_csv(readr_example("challenge.csv"), 
                       col_types = cols(
                         x = col_double(),
                         y = col_date()
                      #col_types = "ncd"
                       ))
challenge2
tail(challenge2)
