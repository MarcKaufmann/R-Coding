# Lecture 7



# Chapter 12: Tidy Data

table4a
# Afg: One row for 1999, and one for 2000.
# We have to have a table with columns:
# - Country
# - Year
# - Value

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

