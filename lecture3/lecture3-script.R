# Lecture 3 Script
# First choose a new team for next week
library(readr)
dir <- Sys.getenv("R_CODING")
student_first_names <- read_csv(paste0(dir,"lecture2/student-names.csv"))
library(tidyverse)
sample_n(student_first_names,4)

# Follows Grolemund and Wickham, chapter 5


# Install the dataset if you don't have it
# install.packages("nycflights13")
library(nycflights13)
flights
?flights
View(flights)
view(flights)
?view

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
filter(flights, dep_time == 517)

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
# |: is 'or' operator
(jan_feb <- filter(flights, month == 1 | month == 2))
(not_jan <- filter(flights, !(month == 1)))

# Class exercise: How do we know these actually worked?
filter(not_jan, month == 1)
View(jan_feb)
unique(not_jan$month)
jan <- filter(flights, month == 1)
nrow(flights) == nrow(jan) + nrow(not_jan)

(jan_to_june1 <- filter(flights, month <= 6))
jan_to_june2 <- filter(flights, month %in% c(1,2,3,4,5,6))
# Check same number of observations
nrow(jan_to_june1) == nrow(jan_to_june2)

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
# late but didn't start quite as late
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

# Class exercise (do at home): How can we get the missing values at the top?


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

# Notice that the data doesn't have to be mentioned, 
# and the first argument should not have to be provided

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
# For more do
?select

# Function for renaming columns
rename(flights, destination = dest)

# Hard to see if it worked, so...
flights %>% rename(destination = dest) %>% select(year:day, destination)

# Moving some columns to the start
select(flights, origin, dest, everything())

# Class Exercise: What happens if you include a variable multiple times?

## Assignment 4

# ## Resources
# 
# - If you have no experience coding, this may be helpful: https://rstudio-education.github.io/hopr/
# 
# ## Assignment 4
# 
# 1. Read Chapter 5 of Grolemund and Wickham parts 1 through 4 (including select) of Grolemund and Wickham for anything we did not cover. We will cover the remaining parts next week.
# 2. Turn the script (.R file) from class into a markdown file which displays the graphs and tables. Add any comments that might benefit you later on, such as reminders of things you found confusing, etc.
#   Make sure that you comment the graphs where appropriate, either through captions or in the accompanying text.
# 3. Repeat the steps from chapter 5 in parts 1 through 3, but using hotels data instead of the nycflights data. 
# Since the two datasets don't have the same columns, either pick some variable you'd like to filter on and see results on, or use the following suggested mapping:
# Repeat every step for which Grolemund and Wickham show the output - thus ignore all the exercises, or options they mention without.
#   - When filtering (etc) on month for flights, use stars in the hotels data
#   - Instead of flight duration, use hotel price
#   - For travel times, use distance (you can reuse distance for different types of time)
# 
# Example: Instead of doing
# filter(flights, month == 1)
# you should do
# filter(hotels, stars == <some-number-you-like>)
# Create similar output to Grolemund and Wickham, i.e. show what the output is of various commands.
# 
# See (Discourse)[https://discourse.trichotomy.xyz/t/week-4-assignment-description/89/2] for an example of what counts as a step.
