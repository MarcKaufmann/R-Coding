# Name of submitter: <ADD YOUR NAME HERE!>
library(dplyr)
library(stringr)

# Exercise 1: Define the function sq that squares a single number x
sq <- function(x) {
  x  # FIXME
}

# Exercise 2: From the `starwars` data, get all the non-human characters with 
# eyes that contain yellow or blue-gray.
# Keep all the columns.
non_human_eyes <- starwars # FIXME

# Exercise 3: write the body of the function `non_human_hair` that takes a single argument.
# This argument is a subset from the `starwars` data, and your function should return all the
# non-human characters who COULD POSSIBLY have brown, auburn, or no hair
# Keep only the following columns: name, species, eye_color, homeworld, and hair_color IN THAT ORDER
# Order the rows by species, then eye_color, both ascending alphabetically
non_human_hair <- function(df) {
  df #FIXME: write as function
}

# Use the `msleep` data (bulit-in dataset in the ggplot2 package) for Exercises 4-7


# Exercise 4. Get all the animals who are heavier than the average bodyweight in the data
# Keep the "name" and "bodywt" of these animals
# Order the rows by bodyweight in a descending order
heavy_animals <- msleep # FIXME

# Exercise 5. Create a new column called brainwt_ratio showing the ratio of
# of brain mass to the total body weight. Round the ratio to 4 digits. Keep the 
# name and brainwt_ratio colums and keep the 10 animals with the highest 
# relative brain mass.

clever_animals <- msleep # FIXME

# Exercise 6 Create a new column called brainwt_ratio (as described in previous 
# exercise), and keep only this column. Use the transmute command.
brainweight <- msleep #FIXME

# Exercise 7 Check whether carnivores, herbivores, insectivores, or omnivores 
# sleep more. To do so, remove the rows where vore is missing (NA).
# Then create a data table with 4 rows and 3 columns showing the average,
# and the standard deviation for total sleep time for the 4 types of vores. 
# Order them alphabetically by vore.
meansleep_by_vore <- msleep #FIXME

