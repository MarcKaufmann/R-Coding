# First name: <PUT YOUR NAME HERE>
library(tidyverse)
library(nycflights13)

# When you get stuck, read the help on the functions that you are using;
# search the help (via `??`) for specific types of functions, or read
# about a library; post on Slack or search online.


# Exercise 1: Use the "planes" dataset from the nycflights13 library.
# Generate a table where you can look at the models of each manufacturer. Specifically,
# make a tibble called manus_models  where there is one row for every manufacturer. Put the name of the manufacturer
# in the first column, and the models of this manufacturer to the next columns called 
# model1, model2, model3, etc. Every  model should only appear once. If a manufacturer has only one model,
# model2, model3 etc should be NA  Arrange the manufacturers alphabetically.
# You should get a tibble with 35 observations and 66 variables

manus_models <- planes #fix me



# Exercise 2: Using the flights and weather data generate a tibble where all values and
# variables are kept from the flights data, and in a new column called temp you include 
# the average temperature on the given day (you can calculate this from the weather dataset)



flights_temp<- #fix me
  

# Exercise 3: Generate a tibble using the airports dataset, which contains data 
# a) only on airports which appear as destinations in the flights dataset. Keep all columns from airports
airports_in_flights <- #Fix me 
# b) only on airports which do not appear as destinations in the flights dataset. Keep all columns from airports
airports_notin_flights <- #Fix me 
  
  
# Exercise 4: Using the msleep data look at the relationship between body weight
# and sleep time. 
  
# First, generate a scatterplot with bodyweight on the x axis
# and sleep_total on y, fit a linear line to the points and show the
# 90% confidence interval as well

ggplot #fixme

# Then, fit a linear model, store it in model1.
model1 <- #fixme

# Look at the plot of the residuals vs the fitted values. 


# Keep animals only with bodyweight below 100 and run a linear model again.

model2<-#fixme


#Run a model (use all animals) where you include the logged value of bodyweight on the right hand side

model3<-#fixme

        
#Run a model where along with log bodyweight you include vore on the right hand side.
#Set the reference category to herbivore in the model

        
model4<-#fixme



#Write a short intelligent discussion on what you learnt about the relationship between
#body weight and sleep time (max 10 sentences). Which model is your favorite from
#models 1-4 to describe the relationship, and why? You can use coefficients, R squares, significances,
#diagnostic plots, whatever you want, in your argument.
