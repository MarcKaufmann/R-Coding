# Lecture 8


# Tailnum is a primary key

# Is flight number a primary key for a flight by day?

# Add a primary key

## Mutating Joins

# Reduce number of cols to see what changes with joins


# Strong recommendation:
# Work through sections 13.4.1 and following to understand joins



# Get weather for NY airports

# Get weather for destination airports

# Why did that not work? Because we only have the following airports:

# Difference with merge:
# 'The advantages of the specific dplyr verbs is that they more clearly convey 
# the intent of your code: the difference between the joins is really important 
# but concealed in the arguments of merge(). dplyr’s joins are considerably 
# faster and don’t mess with the order of the rows.'

# 13.5 Filtering Joins

# Find the top 10 most popular destinations (total flights per year)

  
# Get only the flights to the top destinations


# Get the flights to the top 11 destinations


# `semi-join()` expresses intent clearer, more self-documenting.
# I prefer it.
# Semi-join is more convenient with multiple fields


# Try this without semi-join

# Anti-join gets the rows that do not match in the second table

# 3 steps to make sure the join works
# 1. What is the primary key? Is it a primary key, i.e. it is unique?
# 2. Is the primary key present for all?
# 3. Do the primary and foreign keys match in the way we expect? Use anti_join for this

# Be aware of setdiff, intersect, and union

# Chapter 23


# sim1 dataset comes with modelr

# This creates a data frame of model parameters


# Take model and data and plots the model for all the x's in the data
# Computes the y-value for the x-value in the data, predicted by linear model a


# mean-squared error is the benchmark error used

# Helper function. 
# We need it to package two individual parameters into a single vector of parameters

# Some nice functional code (my kind of thing)
# Computes the distance for every model

# Get the best models

# Plot the lines of the best models

# Now plot the parameters for all our models
# Highlight the best models

# This was a weird way of getting OK models
# Let's use buil-in optimization tools to find the 'optimal' values of parameters
# It optimizes (minimizes) the function we tell it, and starts at c(0,0) in this case

# That looks much better!

# finding the 'best' linear model is so common, it's built in (or coures)
# Check the parameter is the same

# This is the right way of doing it, but the `optim()` generalizes to
# other types of cost functions etc. You should know about it, 
# for most of you only so you realize this is what some functions do in
# the background (well, a generalized version of it). 
# That's why you sometimes have to specify a seed or starting point
# as well as a loss or cost function

# Add predictions and residuals to df
# Convenience functions provided by modelr

# Plot the predicted points. Obviously they are on the line.

# Do the residuals look randomish? 

# You can also use predict and residuals from base R, but make sure you haven't
# changed the order of the rows on the dataset!

# New dataset to illustrate other linear models and how we can specify them




# You can use transformations in formulas

# You have to wrap parts of the formula that use *, +, - or ^ into I(), in order to have correct
# interpretations. 


# Whenever transformations get complicated, do the transformation first on 
# the data frame, then write the formula simply

# Assignment

# Exercise 1. Merge the two Vienna datasets into one. Which hotels do not have 
# matches in the price data? Use anti_join.
#
# Exercise 2. Come up with 3 models to explore what drives the price of 
# hotels in Vienna. Plot the price of hotels against some of the main variables
# that seem to have the most explanatory power.

# Exercise 3. Look at the residuals from your favorite model. Now plot these 
# against 3 variables that you didn't include earlier - or if you included all
# plot them agains some variables in a form that you did not do before 
# (squares, logs, interactions). Do the residuals look random? 

# Exercise 4. Try to find out some methods to check if residuals are random and 
# how to code this in R. Find at least two ways.

# Exercise 5. Use your model estimated on Vienna to predict prices for another city.
# How well does your model do, if you use the parameter values estimated on Vienna?

# Exercise 6. Reestimate your favorite model (the same as from exercise 1) for
# another city. How much do the parameter values change? How well does the model
# do now? If you had to summarise the difference between the 2 cities in one 
# number based on your model, what would it be?