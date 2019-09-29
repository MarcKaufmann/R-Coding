#############################################
# hotel-vienna cleaning
#
# hotels
# input:
# hotelbookingdata-vienna.csv

# output:
# hotel-vienna.csv

#############################################
# Clear memory
rm(list=ls())

dir <- "C:/Users/GB/Dropbox (MTA KRTK)/bekes_kezdi_textbook"

#location folders
data_in <- paste0(dir,"/cases_studies_public/hotels-vienna/raw/")
data_out <- paste0(dir,"/cases_studies_public/hotels-vienna/clean/")

# PACKAGES
library(dplyr)


### IMPORT AND PREPARE DATA

# variables downoaded as string, often in form that is not helpful
# need to transform then to numbers that we can use

df <- read.csv(paste0(data_in,"hotelbookingdata-vienna.csv"), stringsAsFactors = F)

# generate numerical variable of rating variable from string variable
#  trick: remove non-numeric characters using regex

# distance to center entered as string in miles with one decimal
df$distance <- as.numeric(gsub("[^0-9\\.]","",df$center1distance))
df$distance_alter <- as.numeric(gsub("[^0-9\\.]","",df$center2distance))

# parsing accommodationtype column
# replace missing values to handle split
#df[df$accommodationtype == "_ACCOM_TYPE@",]$accommodationtype <- "_ACCOM_TYPE@NA"
df$accommodation_type <- unlist(sapply(strsplit(as.character(df$accommodationtype), "@"), '[[', 2))
df$accommodationtype <- NULL

# number of nights variable
df$nnights <- 1

# ratings
# generate numerical variable of rating variable from string variable
# remove /5

df$rating <- as.numeric(gsub("/5","",df$guestreviewsrating))

# check: frequency table of all values
table(df$rating)

# RENAME VARIABLES
colnames(df)[colnames(df)=="rating_reviewcount"] <- "rating_count"
colnames(df)[colnames(df)=="rating2_ta"] <- "ratingta"
colnames(df)[colnames(df)=="rating2_ta_reviewcount"] <- "ratingta_count"
colnames(df)[colnames(df)=="addresscountryname"] <- "country"
colnames(df)[colnames(df)=="s_city"] <- "city"

# look at key vars
colnames(df)[colnames(df)=="starrating"] <- "stars"
table(df$stars)
df$stars[df$stars == 0] <- NA

table(df$rating)

# drop if hotel id is missing
df <- df[!is.na(df$hotel_id), ]

# drop vars
df$center2distance <-  NULL
df$center1distance <-  NULL
df$price_night <- NULL
df$guestreviewsrating <- NULL

# DROP PERFECT DUPLICATES
df[duplicated(df)==T,]
#these are perfect duplicates of the observation in the previous row
df <- df[!duplicated(df), ]

# drop if the row is the same based on the most important variables
df <- df[!duplicated(subset(df, select = c(city, hotel_id, distance, stars, rating, price, year, month, weekend, holiday))), ]

write.csv(df, paste0(data_out,"hotels-vienna_price"), row.names = F)
