## Intro to R: Class 1

## Coding for Economics/Stata/Scientific Python/machine learning/SPSS

# Things To Know about R
# 1. Everything has a name
2
4 + 7
7/3
7 %% 3
x^2
2^2
2^3
# When you are on a line, hit <ctrl-enter>
2**3

# Pre-defined variables
pi
"pi"
'pi'
"pi" == 'pi'
TRUE
True
true
FALSE
F
T
3
3 == 4
TRUE
FALSE == FALSE

# Pre-defined functions
c
C
"C"

# 2. Everything is an object

marcs_new_object <- "I am a fancy object"
marcs_new_object
marcs_new_combined_object <- c(marcs_new_object, "Some apples, because they are healthy")
marcs_new_combined_object                               
c(1, "and this", "and that")
c(1, 2, 3)
range(100)
seq(100)
seq(10)
rep("This and that", 10)
?seq
seq(1, 300, 5)
?seq
seq()
seq(from=1, to=300, by=5)
seq(to=300, from=1, by=5)
seq(300, 1, 5)
seq(300, 1, -5)

seq

# You do things using functions

mean
mean()
?mean
mean(c(0, 10))
mean("a")
?NA
NA
na
NA
mean(c(0, 10, NA)) # 5    3.33  NA   0
mean(c(0, 10, NA), na.rm = TRUE)
mean(c(0, 10, "super rich"))

# 4. Functions come in packages

ggplot
library(ggplot2)
ggplot
tibble
??tibble
tibble::tibble
?library
?tibble
??tibble
library("tidyverse")

library(wishful_thinking)
install.packages(wishful_thinking)
install.packages('wishful_thinking')

x <- c(1, 3.0, 2.9)
x
str(x)
