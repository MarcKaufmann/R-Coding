# Lecture 3 Script
# First choose a new team for next week

# Follows Grolemund and Wickham, chapter 5

# Install the dataset if you don't have it
# install.packages("nycflights13")


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

# dplyr functions don't change the data frame that you give it. They return a new one.
# Save the filtered data
# Assign and print, use (varname <- ...)
# Check it really assigned

# Some notes on comparisons

# In short, you can't rely on "It works because it works for what I tried".
# For floating point comparisons, use near() to compare numbers

# Exercise: What counts as near? Find out. Can you change it?

# Multiple constraints

# Class exercise: How do we know these actually worked?


# Class Exercise: What does this do?
# Vote:
# 1. All flights that started and landed 120 minutes late
# 2. All flights that started 120 minutes late or landed 120 minutes late
# 3. All flights that started less than 120 minutes late or landed less than 120 minutes late
# 4. All flights that started and landed less than 120 minutes late

# Class Exercise: Get the filter command for number ... above


# Class Exercise: get all flights that departed with less than 120 minutes delay,
# but arrived with more than 120 minutes delay.

# Let's look at the data to see what the departure was for planes that arrived 
# late but didn't start quite as late

# Filter flights by those that had dep_delay <= 120, then plot histogram

# NA: Not available

# Nice example from G&W

# Let x be Mary's age. We don't know how old she is.

# Let y be John's age. We don't know how old he is.

# Are John and Mary the same age?
#> [1] NA
# We don't know!



## arrange()

# Class exercise: How can we get the missing values at the top?

# Fastest flight

# Better ways of getting some special columns

# select()

# That's tedious to write. Hence the pipe.

# Notice that the data doesn't have to be mentioned, 
# and the first argument should not have to be provided

# Some helper functions

# Function for renaming columns
# Hard to see if it worked, so...

# Moving some columns to the start

# Class Exercise: What happens if you include a variable multiple times?

## Assignment 4

# ## Resources
# 
# - If you have no experience coding, this may be helpful: https://rstudio-education.github.io/hopr/
# 
# ## Assignment 4
# 
# 1. Read Chapter 5 of Grolemund and Wickham parts 1 through 3 (until select) of Grolemund and Wickham for anything we did not cover. We will cover the remaining parts next week.
# 2. Turn the script (.R file) from class into a markdown file which displays the graphs and tables. Add any comments that might benefit you later on, such as reminders of things you found confusing, etc.
#   Make sure that you comment the graphs where appropriate, either through captions or in the accompanying text.
# 3. Repeat the steps from chapter 5 in parts 1 through 3, but using hotels data instead of the nycflights data. Since the two datasets don't have the same columns, either pick some variable you'd like to filter on and see results on, or use the following suggested mapping:
#   - When filtering (etc) on month for flights, use stars in the hotels data
#   - Instead of flight duration, use hotel price
#   - For travel times, use distance (you can reuse distance for different types of time)
# 
# Example: Instead of doing
# filter(flights, month == 1)
# you should do
# filter(hotels, stars == <some-number-you-like>)
# Create similar output to Grolemund and Wickham, i.e. show what the output is of various commands.
