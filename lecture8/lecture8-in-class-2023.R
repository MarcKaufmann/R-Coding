# Lecture 8


...

# Chapter 11: Data Import

(test_data1 <- read_csv("lecture6/test-data.csv"))

read_csv(
  "dfjdksfjdlkfsjdlkjf
  a,b,c
  1,2,3
  4,5,6",
  skip = 1)
)

read_csv(
  "1,2,3
  4,.,6",
  col_names=c("First", "Second", "Third"),
  na = ".")

?read_delim
?read_tsv
?read_csv2

# Class Exercise 5 in 11.2
# IDentify what is wrong with each of 

# "\n" is the newline character in many programming
read_csv("a,b,c
         1,2,3
         4,5,6")
read_csv("a,b,c,d
         1,2
         1,2,3,4")
read_csv("a,b\n\"1")
read_csv("a,b\n1,2\na,b\n1,2\na,b", col_names=FALSE)
read_csv2("a;b\n1;3")
