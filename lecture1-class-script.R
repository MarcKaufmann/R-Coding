# 1. Everything has a name
# Basic Arithmetic
2 
4 + 7
7/3
7 %% 3
7//3
7 %/% 3
x^2
2^2
2*2
# caret (^)
3*2
3^2
3**2

# Pre-defined variables
pi
"pi"
'pi'
"pi" == 'pi'
TRUE
true
FALSE

# Pre-defined functions
c
c(0)
0
0 == c(0)
c(0, 1)
c(0, 0, 0, 0, 0, 0)
help(c)
"c"
"c(0)"
C
c

# 2. Everything is an object

marcs_new_object <- "I am a fancy object" # a = 1; a == 1; 1 == a; 1 = a
marcs_new_object

marcs_new_combined_object <- c(marcs_new_object, "Some apples, because they are healthy")
marcs_new_combined_object

list_of_p_languages <- c(
  "Racket",
  "SQL",
  "R",
  "Python",
  "Javascript",
  "Matlab",
  "Julia",
  "Maple", # Maths
  "Processing", # Graphics
  "assembly",
  "C", # The mother of all modern languages
  "C++",
  "C#",
  "Scratch", # For Kids (and adults who remain kids)
  "DAX" # Power BI
)
length(list_of_p_languages)
languages_heard_of <- c(
  10,
  12,
  8,
  11,
  11,
  10,
  10,
  7,
  10,
  10,
  9,
  8,
  11,
  9,
  9,
  10,
  10,
  14
)

# 3. You do things using functions

mean
mean(c(0, 10))
mean(languages_heard_of)
mean("a")
NA
help(NA)
mean(c(0, NA))
mean(c(0, NA), na.rm = TRUE)

# 4. Functions come in packages

ggplot
library(ggplot2)
# install.packages("ggplot2")
ggplot()

# Importing can mask other definitions
library(dplyr) # masks filter and lag (among others)

# How to figure out what is what
x <- c(0, 3.0, 2.9)
x
str(x)
x[[1]]
x[[0]]
x[c(1,2)]
y <- c(0, 1)
y <- c("1", "3.0", "2.9")
y
str(y)
class(y)
z <- c("1", 1)
z
w <- list("1", 1)
w
str(w)

# help

help(summary)
