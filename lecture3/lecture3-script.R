# Lecture 3 Script

# git push/pull dance for practice
# Recap from ggplot, with data from two datasets on the same plot

# Follows Grolemund and Wickham, chapter 5

# Install the dataset if you don't have it
# install.packages("nycflights13")
library(nycflights13)
flights
?flights
View(flights)
view(flights)
?view # confusing that this works -- it is not loaded, that's why it fails, while utils::View(flights) does work

library(tidyverse)
# Today, we'll cover
# - filter()
# - arrange()
# - select()

# Next week, we'll cover
# - mutate()
# - summarise()
# - group_by(), which tells the other verbs to use the data by groups

# All take as first argument a data frame (or tibble) and return a data frame (or tibble).
# Together they form the verbs of the tidyverse.

# Class Exercise: For 2 minutes, think about why it is a nice property (and a conscious design choice)
# that all verbs take as a first argument a data frame and return a data frame. Talk with your
# neighbour about this.

# Filtering (choosing) rows with filter()

filter(flights, month = 1) # Produces an error
filter(flights, month == 1)
filter(flights, month == 1, day == 1)
filter(flights, dep_time == 517) # What format is dep_time in?

# dplyr functions don't change the data frame that you give it. They return a new one.
flights
# Save the filtered data
jan1 <- filter(flights, month == 1, day == 1)
jan1
# Assign and print, use (varname <- ...)
(feb1 <- filter(flights, month == 2, day == 1))
# Check it really assigned
feb1

# Some notes on comparisons
sqrt(2)^2 == 2
sqrt(4)^2 == 4
(1/3)*3 == 1
1/49*49 == 1
1/(7^9)*7^9 == 1
# In short, you can't rely on "It works because it works for what I tried".
# For floating point comparisons, use near() to compare numbers
near(sqrt(2)^2, 2)

# Exercise: What counts as near? Find out. Can you change it?

# Multiple constraints
# '|' is 'or' operator
(jan_feb <- filter(flights, month == 1 | month == 2))
# '!' is the 'not' operator
(not_jan <- filter(flights, !(month == 1)))

# Class exercise: How do we know these actually worked?
filter(not_jan, month == 1)
View(jan_feb)
unique(not_jan$month) # $ chooses the column
jan <- filter(flights, month == 1)
nrow(flights) == nrow(jan) + nrow(not_jan)

(jan_to_june <- filter(flights, month <= 6))
jan_to_june_again <- filter(flights, month %in% c(1,2,3,4,5,6))
# Check same number of observations
nrow(jan_to_june) == nrow(jan_to_june_again)

# Class Exercise: What does this do?
mystery_filter <- filter(flights, !(arr_delay > 120 | dep_delay > 120))
mystery_filter2 <- filter(flights, arr_delay <= 120, dep_delay <= 120)
mystery_filter
mystery_filter2

# arr_delay > 120 OR dep_delay > 120
# True if:
# - (140, 140)
# - (140, 0)
# - (0, 140)
# - (0, 0)
# Vote:
# 1. All flights that started and landed 120 minutes late
# 2. All flights that started 120 minutes late or landed 120 minutes late
# 3. All flights that started less than 120 minutes late or landed less than 120 minutes late
# 4. All flights that started and landed less than 120 minutes late

# How to convince ourselves? could use row_number() to add row_number and check the same row numbers are in both filters
# Class Exercise: Get the filter command for number 3 above
# 3. All flights that started less than 120 minutes late or landed less than 120 minutes late
number3 <- filter(flights, arr_delay <= 120 | dep_delay <= 120)
number3 <- filter(flights, arr_delay < 120 | dep_delay < 120)

# Class Exercise: get all flights that departed with less than 120 minutes delay,
# but arrived with more than 120 minutes delay.
dep_ok_arr_not <- filter(flights, dep_delay <= 120, arr_delay > 120)

ggplot(data = dep_ok_arr_not,
       mapping = aes(x = dep_delay)) +
  geom_histogram()

# Let's look at the data to see what the departure was for planes that arrived 
# late in general
ggplot(data = flights,
       mapping = aes(x = dep_delay)) + 
  geom_histogram()

# Filter flights by those that had dep_delay <= 120, then plot histogram
dep_ok <- filter(flights, dep_delay <= 120)
ggplot(data = dep_ok,
       mapping = aes(x = dep_delay)) + 
  geom_histogram()


# NA: Not available

NA > 5
10 == NA
NA == NA
FALSE & NA
TRUE & NA
NA & FALSE

# Nice example from G&W

# Let x be Mary's age. We don't know how old she is.
x <- NA

# Let y be John's age. We don't know how old he is.
y <- NA

# Are John and Mary the same age?
x == y

# We don't know!

NA^0
0 * NA

is.na(x)
df <- tibble(x = c(1, NA, 3))
df
filter(df, x > 1)
filter(df, x > 1 | is.na(x))


## arrange()

flights
arrange(flights, year, month, day)
arrange(flights, dep_delay)
arrange(flights, desc(dep_delay))

arrange(df, x)
arrange(df, desc(x))

# Class exercise (do at home): How can we get the missing values at the top? Use `is.na()`


# Fastest flight
colnames(flights)
arrange(df, air_time)
arrange(flights, air_time)

# Better ways of getting some special columns

# select()

select(flights, year, month, day)

select(arrange(flights, air_time), air_time, origin, dest)

# That's tedious to write. Hence the pipe.

flights %>%
  arrange(air_time) %>%
  select(air_time, origin, dest)

# Notice that the data doesn't have to be mentioned in the call, 
# it gets used as the first argument automatically. Therefore
# the first argument should not be provided

select(flights, year:day)
# Same as ..
flights %>% select(year:day)
colnames(flights)

# dropping cols
select(flights, -(year:day))

# Some helper functions
select(flights, starts_with("arr"))
select(flights, -starts_with("arr"))
select(flights, ends_with("hour"))
select(flights, -contains("time"))
# What does the following do? Is that as expected?
select(flights, -contains("time"), starts_with("arr"))
# If you want those that satisfy both conditions, need two calls
flights %>% 
  select(-contains("time")) %>%
  select(starts_with("arr"))
# For more do
?select

# Function for renaming columns
rename(flights, destination = dest)

# Hard to see if it worked, so...
flights %>% rename(destination = dest) %>% select(year:day, destination)

# Moving some columns to the start
select(flights, origin, dest, everything())

# Class Exercise: What happens if you include a variable multiple times?

# ## Resources
# 
# - If you have no experience coding, this may be helpful: https://rstudio-education.github.io/hopr/
