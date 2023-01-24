# Lecture 3 Script in class

# For latex, install tinytex
install.packages("tinytex")

# git pull

# R4DS Chapter 5

install.packages("nycflights13")
library(nycflights13)
flights
?flights
View(flights)
view

library(tidyverse)
# Today:
# - filter()
# - arrange()
# - select()
# - rename()
# Next class
# - mutate()
# - summarise()
# - group_by()

# Each of these takes a df (dataframe) as first argument and returns a df.

# Filtering chooses rows of a dataframe
flights
jan_flights <- filter(flights, month == 1)
filter(jan_flights, month != 1) # Checking that it is empty
jan3 <- filter(flights, month == 1, day == 3)
filter(flights, dep_time == 517)
?flights

# Cautionary notes on comparisons

2 == 2
2 == 2.0
sqrt(2)^2 == 2
sqrt(4)^2 == 4
(1/3)*3 == 1
(1/49)*49 == 1
1/(7^9)*7^9 == 1
near(sqrt(2)^2, 2)

# Multiple constraint
# '|' is 'or' operator
(jan_feb <- filter(flights, month == 1 | month == 2))
# '!' is the 'not' operator
(not_jan <- filter(flights, !(month == 1)))

# stopifnot checks that the condition holds, otherwise it throws an error
stopifnot(nrow(flights) == nrow(jan_flights) + nrow(not_jan))

mystery_filter <- filter(flights, !(arr_delay > 120 | dep_delay > 120))
mystery_filter2 <- filter(flights, arr_delay <= 120, dep_delay <= 120)

# Vote:
# 1. all flights that started and landed 120 minutes late     ;; 0
# 2. started 120 minutes late or landed 120 minutes late      ;; 2
# 3. started less than 120 minutes late or landed less than 120 minutes late ;; 5
# 4. started and landed less than 120 minutes late ;; 7

# (140, 140): FALSE
# (140, 0): FALSE
# (0, 140): FALSE
# (0, 0): TRUE

# Class Exercise: all flights that departed with less than 120 minutes delay,
# but arrived with more than 120 minutes delay.

dep_ok_arr_not <- filter(flights, arr_delay > 120, dep_delay < 120)

ggplot(data = dep_ok_arr_not,
       mapping = aes(x = dep_delay)) + 
  geom_histogram()

ggplot(data = flights,
       mapping = aes(x = dep_delay)) + 
  geom_histogram()


# NA: Not Available

NA > 5
10 == NA
NA == NA
FALSE & FALSE
FALSE & TRUE
TRUE & TRUE
FALSE & NA
TRUE & NA
NA & FALSE

is.na(NA)
is.na(TRUE)

# x is Mary's age
x <- NA
# y is John's age
y <- NA
x == y

NA^0
0 * NA
1/0
0 * Inf
Inf^0

is.na(x)
df <- tibble(x = c(1, NA, 3))
df
filter(df, x > 1)
filter(df, x > 1 | is.na(x))

# arrange()

flights
arrange(flights, year, month, day)
arrange(flights, dep_delay)
arrange(flights, desc(dep_delay))

arrange(df, x)
arrange(df, desc(x))
arrange(df, desc(is.na(x)), desc(x))
arrange(df, x, desc(x))

colnames(flights)
# Fastest flight

arrange(flights, air_time) # Can't see column air_time

# select

select(flights, year, month, day)

# Fastest 
select(arrange(flights, air_time), air_time, carrier)

# Easier way for multiple transformations: use the pipe, %>%
flights %>%
  arrange(air_time) %>%
  select(air_time, carrier)

select(flights, year:day)
flights
select(flights, year:arr_time)

# Dropping columns
select(flights, -(year:day))
select(flights, -year, -day)
select(flights, starts_with("arr"))
select(flights, ends_with("hour"))
select(flights, -ends_with("hour"))

# What does this do?

select(flights, -contains("time"), starts_with("arr"))
select(flights, -contains("time") & starts_with("arr"))
flights %>%
  select(-contains("time")) %>%
  select(starts_with("arr"))

?select

rename(flights, destination = dest)
# To check it worked
flights %>%
  rename(destination = dest) %>%
  select(year:day, destination)

select(flights, origin, dest, everything())

flights <- rename(flights, destination = dest)
flights
select(flights, origin, dest, everything())

# Exercise: What happens if you include the same column multiple times?
select(flights, year, year, month, year, year)
