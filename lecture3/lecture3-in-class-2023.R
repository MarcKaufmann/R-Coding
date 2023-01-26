# Lecture 3
# Assignment 1
# Knitting last time with View
# Just comment out `View(gapminder)`

# Follows R4DS, chapter 5

# install.packages("nycflights13")
library(nycflights13)
flights
?flights
View(flights)
view(flights) # throws an error

library(tidyverse)
# Today: filter(); arrange(); select();
# Next week: mutate(); transmute(); group_by() and summarize()
# All of these take as their first argument a tibble (a tidyverse version of dataframe)

# Aside: if you want faster code, look at data.table

# Filtering
dim(flights)
filter(flights, month == 1)
filter(flights, month = 1) # Throws error
unique(flights$month)
jan_flights <- filter(flights, month == 1)
unique(jan_flights[['month']])
dim(jan_flights)
flights  
?unique
unique(c(0, 0, 0, 1, 1, 2))

# To ensure your code stops if some condition is not met
stopifnot(unique(jan_flights[['month']]) == c(1))
flights[1, ] # Get row number 1 (starts counting at 1!!)
flights[1, 2] # Get data in row 1, column 2
flights[1, 'month'] # Get data in row 1, column named 'month' -- better than by number
flights[c('month', 'year')] # DON'T DO THIS IF YOU WANT A SINGLE COLUMN!!! 
flights['month']
flights[['month']] # Use this syntax if you really want a single column as a vector
flights$month

jan_1 <- filter(flights, month == 1, day == 1)
tempflights <- flights
flights <- filter(flights, month == 1)
flights
flights <- tempflights

(feb1 <- filter(flights, month == 2, day == 1))

# Some notes on comparisons
sqrt(2)^2 == 2
sqrt(4)^2 == 4
(1/3)*3 == 1
(1/49)*49 == 1
1/(7^9)*7^9 == 1
near(sqrt(2)^2, 2)
?near

# Multiple constraints
# '|' is 'or' operator
(jan_feb <- filter(flights, month == 1 | month == 2))
# '!' is 'not' operator
(not_jan <- filter(flights, !(month == 1)))
(not_jan <- filter(flights, month != 1))
not_jan
View(not_jan)
(before_june <- filter(flights, month <= 6))
jan <- filter(flights, month == 1)
feb <- filter(flights, month == 2)
# To check that jan_feb is what it should be
stopifnot(nrow(jan_feb) == nrow(jan) + nrow(feb))
near(sqrt(2), 1.414, tol=0.1)

# Class exercise: get all flights that departed with less than 120 minutes delay
# but arrived with more than 120 minutes delay
# dep_delay, arr_delay
(dep_ok_arr_not <- filter(flights, dep_delay <= 120, arr_delay >= 120))
(dep_ok_arr_not <- filter(flights, (dep_delay <= 120) & (arr_delay >= 120)))
dep_ok_arr_not_pipe <- flights |>  # |> is the pipe operator in base R; %>% is pipe in tidyverse
  # the pipe takes the object on its left, and puts it as the first argument
  # to the function on the right
  filter(
    # flights
    dep_delay <= 120,
    arr_delay >= 120
  )

# arrange
flights
arrange(flights, year, month, day)
arrange(flights, dep_delay)
arrange(flights, desc(dep_delay))

arrange(jan, desc(month))
(df <- tibble(x = c(1, NA, 3)))

# NA: Not Available

NA > 5
10 == NA
NA == NA
FALSE & NA
TRUE & NA
TRUE | NA
NA & FALSE
0 * NA
0 * Inf
NA^0
0^NA
0^0
0^2
