# Lecture 11: functions and iterations

## DR3 Notes
#
# 1. If you have lots of nested `if_else` clauses, use `case_when` instead
# 2. For plots, order things sensibly: 
#   - The order is "decreases by more", "decreases the same", "decreases less", 
#     "stays the same", "increases"
#   - You can reverse the order (both are monotonic), but don't mix, it makes 
#     the graph nearly uninterpretable
# 3. If you plot numbers as percentages, make sure to show varying baselines or 
#    make them transparent. So if you split gender by "male", "female", and 
#    "other", then you cannot compare means if the "other" group contains 5 
#    people.

## To learn more about how to define functions, read Chapter 25 of R4DS(2e)

## We follow https://r4ds.hadley.nz/functions#data-frame-functions

library(tidyverse)

grouped_mean <- function(df, group_var, mean_var) {
  df |> 
    group_by(group_var) |> 
    summarize(mean(mean_var))
}

grouped_mean(diamonds, cut, carat)

# What is going on? Well let's run the code inside the function as is. But we 
# have to define the variables as if we did run the function first.
df <- diamonds
group_var <- cut
mean_var <- carat

# Ah yes, well, carat is of course interpreted as the name of a column inside
# of `summarize(mean(carat))`, but here it is not yet defined.

# Why did `cut` work? Because it is a function!!!
group_var

# OK, so let's do it again, now defining the variables as strings to avoid 
# this problem for now, since `select(df, "cut")` is the same as `select(df, cut)`.
select(df, "cut")
select(df, cut)

group_var <- "cut"
mean_var <- "carat"

df |> 
  group_by(group_var) |> 
  summarize(mean(mean_var))

# Same error! What does the error say? Problem in first part, so let's just run
# that.
df |> group_by(group_var)

# What is going on? Data masking in tidyverse.
df |>
  group_by(group_var) # Says: group by the variable in column group_var!

# How do we tell it to group by the variable found in the column whose name is
# the *value* stored in group_var? Tidyeval is getting in the way, because it
# interprets variable names as the names of columns, not as variables.

# With the embrace operator {{ }}
df |>
  group_by({{ group_var }})

# Victory is ours!!

# Define function again
grouped_mean <- function(df, group_var, mean_var) {
  df |> 
    group_by({{ group_var }}) |> 
    summarize(mean({{ mean_var }}))
}

grouped_mean(diamonds, cut, carat)

# Brief detour where you know this kind of thing:
# - "This is my mother": you don't interpret this as me saying that this person
#.  is called "Mymother", even though when I say "This is Tamara", you do think
#.  that the person is called Tamara. Context.
# - Think of it this way: suppose doctor has height, weight, and age of patients. 
#   This is a measure. 
select(df, height) # Get the height. Makes sense.
measure <- "height"
select(df, measure) # Get the measure. Makes no sense - we want to replace by 
# whatever measure we want in this case. Hence
select(df, {{ measure }}) # Check what measure is, then get that column.

# Ready to define our own summary function
my_summary <- function(data, var) {
  data |> summarize(
    min = min({{ var }}, na.rm = TRUE),
    mean = mean({{ var }}, na.rm = TRUE),
    median = median({{ var }}, na.rm = TRUE),
    max = max({{ var }}, na.rm = TRUE),
    n = n(),
    n_miss = sum(is.na({{ var }})),
    .groups = "drop"
  )
}

diamonds |> my_summary(carat)

diamonds |> 
  group_by(cut) |>
  my_summary(carat)

# Gotcha to be aware of
count_missing <- function(df, group_vars, x_var) {
  df |> 
    group_by({{ group_vars }}) |> 
    summarize(
      n_miss = sum(is.na({{ x_var }})),
      .groups = "drop"
    )
}

diamonds |> 
  count_missing(c(cut, carat), price)

# Error in group by. Let's try this:
diamonds |> 
  group_by(c(cut, carat))

# This is the difference between data masking and tidy eval
# select the columns called cut and carat
select(diamonds, c(cut, carat))

# vs group_by the values found in (!!) columns cut and carat, which are large!
group_by(diamonds, c(cut, carat))
# vs group_by the column cut and the column carat
group_by(diamonds, cut, carat)

# Work around with `pick`
group_by(diamonds, pick(c(cut, carat)))

# So:
count_missing <- function(df, group_vars, x_var) {
  df |> 
    group_by(pick({{ group_vars }})) |> 
    summarize(
      n_miss = sum(is.na({{ x_var }})),
      .groups = "drop"
    )
}

diamonds |> 
  count_missing(c(cut, carat), price)

# I don't expect you to get it right now. But I want you to remember these issues
# and look at the error messages, so you know that this can happen and where to
# look it up. (Chapter 25 of R4DS, 2e; data-masking and tidy evaluation)

# Iteration, Functional Programming Style. Chapter 26 R4DS, 2e
# https://r4ds.hadley.nz/iteration

df <- tibble(
  gr = sample(2, 10, replace = T),
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

df |> summarize(
  n = n(),
  a = median(a),
  b = median(b),
  c = median(c),
  d = median(d),
)

# That's tedious. This is better:
df |>
  summarize(
    n = n(),
    across(a:d, median)
  )

# Gotcha:
df |>
  summarize(
    n = n(),
    across(a:d, median())
  )

# What about grouping?
df |>
  group_by(gr) |>
  summarize(
    n = n(),
    across(a:d, median)
  )

# Or if we have potentially a variable number of columns:
df |>
  group_by(gr) |>
  summarize(
    n = n(),
    across(everything(), median)
  )

# Or if we have potentially non-numeric columns:
df |>
  group_by(gr) |>
  summarize(
    n = n(),
    across(where(is.numeric), median)
  )

# What about more flexible function calls?
df2 <- rbind(df, tibble(gr = c(1), a = c(NA), b = c(NA), c = c(NA), d = c(1)))
df2 |>
  group_by(gr) |>
  summarize(
    n = n(),
    across(where(is.numeric), median)
  )

# That's not good. Let's call median with na.rm = T

# Version 1: define new function. 
# Good if repeated use, not if one-off
median_na <- function(x) { median(x, na.rm = T)}

df2 |>
  group_by(gr) |>
  summarize(
    n = n(),
    across(where(is.numeric), median_na)
  )

# Version 2: define anonymous function
df2 |>
  group_by(gr) |>
  summarize(
    n = n(),
    across(where(is.numeric), function(x) median(x, na.rm = T))
  )

# Or
df2 |>
  group_by(gr) |>
  summarize(
    n = n(),
    across(where(is.numeric), \(x) median(x, na.rm = T))
  )

# But now we drop missing values. Let's count them.
df2 |>
  summarize(
    n = n(),
    across(
      where(is.numeric), 
      list(
        median = \(x) median(x, na.rm = T),
        n_miss = \(x) sum(is.na(x))
      )
    )
  )

# Change column names
df2 |>
  summarize(
    n = n(),
    across(
      where(is.numeric), 
      list(
        median = \(x) median(x, na.rm = T),
        n_miss = \(x) sum(is.na(x))
      ),
      .names = "{.fn}_{.col}"
    )
  )

# For filtering:
# same as df_miss |> filter(is.na(a) | is.na(b) | is.na(c) | is.na(d))
df2 |> filter(if_any(a:d, is.na))

# same as df_miss |> filter(is.na(a) & is.na(b) & is.na(c) & is.na(d))
df2 |> filter(if_all(a:d, is.na))

# For more:
vignette("colwise")