###############################################
# Chapter 03
 
# DATA ANALYSIS TEXTBOOK
# CH03
# Describe hotels-vienna
# 

# WHAT THIS CODES DOES:
# Focus on histograms

###############################################



# CLEAR MEMORY
rm(list=ls())

# Import libraries

library(ggplot2)
library(tidyverse)
library(scales)

# set the path
dir <-  Sys.getenv("R_CODING")


#location folders
data_in <- paste0(dir,"da_data_repo/hotels-vienna/clean/")
data_out <-  paste0(dir,"da_case_studies/ch03-hotels-vienna-explore/")
output <- paste0(dir,"da_case_studies/ch03-hotels-vienna-explore/output/")
func <- paste0(dir, "da_case_studies/ch00-tech-prep/")


#call function
source(paste0(func, "theme_bg.R"))




# load vienna
vienna <- read_csv(paste0(data_in,"hotels-vienna.csv"))


####################################################################################
# Figures 3.1
# Flipped bar charts
####################################################################################
# apply filters: Hotels
vienna_cut <- vienna %>% filter(accommodation_type=="Hotel")

histstars_Vienna2 <- ggplot(data = vienna_cut ,aes(x=stars))+
  geom_bar(color = color.outline, fill = color[1], alpha = 0.8, na.rm=T) +
  geom_text(stat='count', aes(label=..count..), hjust=-0.5, size = 3) +
  coord_flip() +
  labs(x="Stars", y="Frequency") +
  scale_x_continuous(limits = c(0.5,5.5), breaks = seq(1, 5, 0.5)) +
  scale_y_continuous(limits = c(0,140), breaks = seq(0, 140, 20)) +
  theme_bg() +
  background_grid(major = "x", minor="x", size.major = 0.2)
ggsave(paste0(output, "histstars_Vienna2_R.png"), width=10, height=7.5, units = "cm", dpi = 1200)
cairo_ps(filename = paste0(output, "histstars_Vienna2_R.eps"),
         width = mywidth_large, height = myheight_large, pointsize = 12,
         fallback_resolution = 1200)
print(histstars_Vienna2)
dev.off()
histstars_Vienna2

histstars_Vienna <- ggplot(data = vienna_cut ,aes(x=stars, y = (..count..)/sum(..count..)))+
  geom_bar(color = color.outline, fill = color[1], alpha = 0.8, na.rm=T) +
  geom_text(stat='count', aes(label=round((..count..)/sum(..count..)*100, 1)), hjust=-0.2, size = 3) +
  coord_flip() +
  labs(x="Stars", y="Percentage") +
  scale_x_continuous(limits = c(0.5,5.5), breaks = seq(1, 5, 0.5)) +
  scale_y_continuous(limits = c(0,0.5), breaks = seq(0, 0.5, 0.1), labels = scales::percent) +
  theme_bg() +
  background_grid(major = "x", minor="x", size.major = 0.2)
ggsave(paste0(output, "histstars_Vienna_R.png"), width=10, height=7.5, units = "cm", dpi = 1200)
cairo_ps(filename = paste0(output, "histstars_Vienna_R.eps"),
         width = mywidth_large, height = myheight_large, pointsize = 12,
         fallback_resolution = 1200)
print(histstars_Vienna)
dev.off()
histstars_Vienna

###############################################
### DISTRIBUTIONS
###############################################
# Apply filters:  3-4 stars, less than 8km from center, without 1000 euro extreme value
vienna_cut <- vienna %>% filter(accommodation_type=="Hotel") %>%
                         filter(stars>=3 & stars<=4) %>% filter(!is.na(stars)) %>%
                         filter(price<=1000)


# brief look at data
table(vienna_cut$city)
table(vienna_cut$stars)

####################################################################################
# Figure 3.2 a) and b)
histprice_Vienna1 <- ggplot(data =  vienna_cut, aes (x = price)) +
  geom_histogram(binwidth = 1,  fill = color[1], size = 0.5, alpha = 0.8,  show.legend=F, na.rm =TRUE) +
  labs(x = "Price", y = "Frequency") +
  scale_x_continuous(limits = c(0,500), breaks = seq(0, 500, by = 100)) +
  theme_bg() +
  background_grid(major = "xy", minor = "y")
histprice_Vienna1
ggsave(paste0(output, "histprice_Vienna1_R.png"), width=12, height=9, units = "cm", dpi = 1200)
cairo_ps(filename = paste0(output, "histprice_Vienna1_R.eps"),
         width = mywidth_large, height = myheight_large, pointsize = 12,
         fallback_resolution = 1200)
print(histprice_Vienna1)
dev.off()

histprice_Vienna2 <- ggplot(data =  vienna_cut, aes (x = price)) +
  geom_histogram(binwidth = 10,  color = color.outline, fill = color[1], size = 0.25, alpha = 0.8,  show.legend=F, na.rm =TRUE) +
  labs(x = "Price", y = "Frequency") +
  scale_x_continuous(limits = c(0,510), breaks = seq(0, 500, by = 100)) +
  theme_bg() +
  background_grid(major = "xy", minor = "y")
ggsave(paste0(output, "histprice_Vienna2_R.png"), width=12, height=9, units = "cm", dpi = 1200)
cairo_ps(filename = paste0(output, "histprice_Vienna2_R.eps"),
         width = mywidth_large, height = myheight_large, pointsize = 12,
         fallback_resolution = 1200)
print(histprice_Vienna2)
dev.off()
histprice_Vienna2


####################################################################################
# Figure 3.3 a) and b)
histprice_Vienna3 <- ggplot(data =  vienna_cut, aes (x = price)) +
  geom_histogram(binwidth = 40,  color = color.outline, fill = color[1], size = 0.25, alpha = 0.8,  show.legend=F, na.rm =TRUE) +
  labs(x = "Price", y = "Frequency") +
  scale_x_continuous(limits = c(0,510), breaks = seq(0, 500, by = 80)) +
  theme_bg() +
  background_grid(major = "xy", minor = "y")
ggsave(paste0(output, "histprice_Vienna3_R.png"), width=12, height=9, units = "cm", dpi = 1200)
cairo_ps(filename = paste0(output, "histprice_Vienna3_R.eps"),
         width = mywidth_large, height = myheight_large, pointsize = 12,
         fallback_resolution = 1200)
print(histprice_Vienna3)
dev.off()
histprice_Vienna3

histprice_Vienna4 <- ggplot(data =  vienna_cut, aes (x = price)) +
  geom_histogram(binwidth = 80,  color = color.outline, fill = color[1], size = 0.25, alpha = 0.8,  show.legend=F, na.rm =TRUE) +
  labs(x = "Price", y = "Frequency") +
  scale_x_continuous(limits = c(0,510), breaks = seq(0, 500, by = 80)) +
  theme_bg() +
  background_grid(major = "xy", minor = "y")
ggsave(paste0(output, "histprice_Vienna4_R.png"), width=12, height=9, units = "cm", dpi = 1200)
cairo_ps(filename = paste0(output, "histprice_Vienna4_R.eps"),
         width = mywidth_large, height = myheight_large, pointsize = 12,
         fallback_resolution = 1200)
print(histprice_Vienna4)
dev.off()
histprice_Vienna4


###############################################
  ### EXTREME VALUES
###############################################
# Apply filters: 3-4 stars, less than 8km from center, without 1000 euro extreme value
vienna_cut <- vienna %>% filter(accommodation_type=="Hotel") %>% 
                     filter(stars>=3 & stars<=4) %>% filter(!is.na(stars)) %>%
                     filter(price<=1000)

########################x
#Figure 3.4
histdist_Vienna <- ggplot(data =  vienna_cut, aes (x = distance)) +
  geom_histogram(binwidth = 0.5, color = color.outline, fill = color[1], alpha = 0.8,  show.legend=F, na.rm =TRUE) +
  labs(x = "Distance to city center (km)", y = "Frequency") +
  scale_x_continuous(limits = c(-1,14), breaks = seq(0, 14, by = 2)) +
  scale_y_continuous(limits = c(0,61), breaks = seq(0, 60, by = 10)) +
  theme_bg() +
  background_grid(major = "xy", minor = "y")
ggsave(paste0(output, "histdist_Vienna_R.png"), width=12, height=9, units = "cm", dpi = 1200)
cairo_ps(filename = paste0(output, "histdist_Vienna_R.eps"),
         width = mywidth_large, height = myheight_large, pointsize = 12,
         fallback_resolution = 1200)
print(histdist_Vienna)
dev.off()
histdist_Vienna

# with annotation
histdist_Vienna_annot <- ggplot(data =  vienna_cut, aes (x = distance)) +
  geom_histogram(binwidth = 0.5, color = color.outline, fill = color[1], alpha = 0.8,  show.legend=F, na.rm =TRUE) +
  labs(x = "Distance to city center (km)", y = "Frequency") +
  scale_x_continuous(limits = c(-1,14), breaks = seq(0, 14, by = 2)) +
  scale_y_continuous(limits = c(0,61), breaks = seq(0, 60, by = 10)) +
  geom_segment(aes(x = 8.2, y = 0, xend = 8.2, yend = 60), color = color[3], size=1) +
  #geom_segment(aes(x = 10, y = 40, xend = 8.4, yend = 40), arrow = arrow(length = unit(0.2, "cm")))+
  annotate("text", x = 11, y = 29, label = "Too far out")+
  annotate("rect",xmin=8.2, xmax=14, ymin=0, ymax=60, fill=color[3], alpha=0.2)+
  theme_bg() +
  background_grid(major = "xy", minor = "y")
ggsave(paste0(output, "histdist_Vienna_annot_R.png"), width=12, height=9, units = "cm", dpi = 1200)
cairo_ps(filename = paste0(output, "histdist_Vienna_annot_R.eps"),
         width = mywidth_large, height = myheight_large, pointsize = 12,
         fallback_resolution = 1200)
print(histdist_Vienna_annot)
dev.off()
histdist_Vienna_annot

# look at actual city
table(vienna_cut$city_actual)

