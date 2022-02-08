# git: what it is and how it works (roughly)
# git clone the repo
# git pull from the repo
# If/when working on assignments in the repository, you should either:
#  i) create a folder that is not stored in git
#  ii) make sure that you commit your changes before you pull from the repo

# Things to Know about R
# 1. Everything has a name
2
4 + 7
7/3
7 %% 3
8 %% 3
x^2
2^2
2*2
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
FALSE

# Pre-defined functions

c
"c"
'c'
"C"

# 2. Everything is an object

marcs_new_object <- "I am a fancy object"
marcs_new_object

marc_new_combined_object <- c(marcs_new_object, "Some apples, because they are healthy")
marc_new_combined_object

list_of_programming_languages <- c(
  "R",
  "SQL",
  "Racket",
  "Lisp",
  "JavaScript",
  "ECMAScript",
  "bash",
  "C",
  "Perl",
  "Logo",
  "Scratch",
  "Julia",
  "Rust",
  "Python"
)

languages_heard_of <- c()
languages_heard_of

# 3. You do things using functions

mean
mean(c(0,10))
mean(languages_heard_of)
mean("a")

# 4. Functions come in packages

ggplot
library(ggplot2)
ggplot
ggplot()
library(wishful_thinking)
install.packages("wishful_thinking")

# How to figure out what is what
x <- c(1, 3.0, 2.9)
x
str(x)
y <- c("1", "3.0", "2.9")
str(y)
y
class(x)
z <- c("1", 1)
z
c("thing", 1010)
list("thing", 1010)
c("thing", 10, function(x) {x})

help(summary)
summary(languages_heard_of)
?summary
# This does not work
?==
help("==")  
?ggplot
?"=="
? == help

# Make the first figures
install.packages("gapminder")
library(gapminder)
gapminder
help(gapminder)
help(tidyr)
??tidyr

plot(gapminder$gdpPercap, gapminder$lifeExp)
p <- ggplot(data = gapminder,
            mapping = aes(x = gdpPercap, y = lifeExp))
p + geom_point()
