#############################################
# Chapter 03
#
# hotels
# input:
# hotelbookingdata.csv

# output:
# hotelbookingdata-vienna.csv

#############################################
 

dir <- "C:/Users/GB/Dropbox (MTA KRTK)/bekes_kezdi_textbook"

#location folders
data_in <- paste0(dir,"/cases_studies_public/hotels-europe/raw/")
data_out <- paste0(dir,"/cases_studies_public/hotels-vienna/raw/")

# PACKAGES
library(dplyr)

### filter Vienna

df <- read.csv(paste0(data_in,"hotelbookingdata.csv"), stringsAsFactors = F)
# filter
df <- df[df$year == 2017 & df$month==11 & df$weekend==0, ]
df <- df[df$s_city == "Vienna",]
write.csv(df, paste0(data_out,"hotelbookingdata-vienna.csv"), row.names= F)

