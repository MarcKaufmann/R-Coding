# Lecture 4 Script
# First choose a new team for next week
library(readr)
dir <- Sys.getenv("R_CODING")
student_first_names <- read_csv(paste0(dir,"lecture2/student-names.csv"))
library(tidyverse)
sample_n(student_first_names,4)

# What if we get the same students as before? How should we do this?

