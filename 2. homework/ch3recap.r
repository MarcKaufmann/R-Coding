---
  title: "Chapter 3 by Kieran Healy"
author: "Akylbek Subanbekov"
date: "September 28, 2019"
output: html_document
---

my_packages <- c("tidyverse", "broom", "coefplot", "cowplot",
                 "gapminder", "GGally", "ggrepel", "ggridges", "gridExtra",
                 "here", "interplot", "margins", "maps", "mapproj",
                 "mapdata", "MASS", "quantreg", "rlang", "scales",
                 "survey", "srvyr", "viridis", "viridisLite", "devtools")

install.packages(my_packages, repos = "http://cran.rstudio.com")

install.packages("rmarkdown")

devtools::install_github("kjhealy/socviz")
1

url <- "https://cdn.rawgit.com/kjhealy/viz-organdata/master/organdonation.csv"

organs <- read_csv(file = url)


url <- "https://cdn.rawgit.com/kjhealy/viz-organdata/master/organdonation.csv"

organs <- read_csv(file = url)


library(gapminder)
library(tidyverse)

library(socviz)
gapminder

p <- ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp))

p + geom_point()


gapminder

p <- ggplot(data=gapminder,
               mapping=aes(x=gdpPercap,
                          y=lifeExp))

p+geom_point()+geom_smooth()

p+geom_point()+geom_smooth(method="lm")

p+geom_smooth(method="lm")+geom_point()

p+geom_point()+geom_smooth(method="gam")+
  scale_x_log10()

#-------------------------------------------------
#To grab a function directly from a library we have not loaded, we use the syntax thelibrary::thefunction.

p+geom_point()+geom_smooth(method="gam")+
  scale_x_log10(labels=scales::dollar)


# trying to change the color in mapping. But, The aes() function is for mappings only. 
#Do not use it to change properties to a particular value.

clr1 <- ggplot(data=gapminder,
            mapping=aes(x=gdpPercap,
                        y=lifeExp,
                        color='purple'))

clr1 + geom_point() +
  geom_smooth(method="loess")+
  scale_x_log10()

#therefore, If we want to set a property, we do it in the geom_ we are using, and outside 
#the mapping = aes(...) step. Try this:


clr2 <- ggplot(data=gapminder,
               mapping=aes(x=gdpPercap,
                           y=lifeExp))

clr2+ geom_point(color="purple", alpha=0.1)+
  geom_smooth(method="loess")+
  scale_x_log10()

#Adding titles and making dots transpafrent by adding alpha to gem_point

clr2+ geom_point(alpha=0.3,color="red")+
  geom_smooth(method="gam", color="purple")+
  scale_x_log10(labels=scales::dollar)+
  labs(x = "GDP Per Capita",
       y = "Life Expectancy in Years",
       title = "Economic Growth and Life Expectancy",
       subtitle = "Data points are country-years",
       caption = "Source:Gapminder")

#coloring continents

cnt <- ggplot(data=gapminder,
               mapping=aes(x=gdpPercap,
                           y=lifeExp,
                           color=continent))
cnt + geom_point()+
  geom_smooth(method="loess")+
  scale_x_log10()

# shading the standard error ribbon of each line to match its dominant color. 
cnt1 <- ggplot(data=gapminder,
              mapping=aes(x=gdpPercap,
                          y=lifeExp,
                          color=continent,
                          fill=continent))
cnt1+geom_point()+
  geom_smooth(method="loess")+
  scale_x_log10()



#Perhaps five separate smoothers is too many, and we just want one line. 
one <- ggplot(data=gapminder,
              mapping=aes(x=gdpPercap,
                          y=lifeExp))

one+geom_point(mapping=aes(color=continent))+
  geom_smooth(method="loess")+
  scale_x_log10()

#It’s possible to map continuous variables to the color aesthetic, too. For example, we can map the log of each 
#country-year’s population (pop) to color. In general it is always worth looking at the data in its continuous form 
#first rather than cutting or binning it into categories.

pop <- ggplot(data=gapminder,
              mapping=aes(x=gdpPercap,
                          y=lifeExp))

pop+geom_point(mapping=aes(color=log(pop)))+
  scale_x_log10()

gapminder
#--------------------------------------------------
  
#3.8 Where to go next
  
# 1. What happens when you put the geom_smooth() function before geom_point() instead of after it? What does this 
#tell you about how the plot is drawn?
  
sw <- ggplot(data=gapminder,
               mapping=aes(x=gdpPercap,
                           y=lifeExp))

sw+ geom_point()+
  geom_smooth(method="loess")+
  scale_x_log10()

sw+geom_smooth(method="loess")+
  geom_point()+
  scale_x_log10()
#----------------
#Change the mappings in the aes() function so that you plot Life Expectancy against population (pop) rather than per capita GDP

ppl <- ggplot(data=gapminder,
            mapping=aes(x=pop,
                        y=lifeExp))
ppl+geom_point(mapping=aes(color=continent))+geom_smooth(method="gam")+
  scale_x_log10()

#----------------------
#Try some alternative scale mappings.scale_x_sqrt() and scale_x_reverse()


p <- ggplot(data=gapminder,
              mapping=aes(x=gdpPercap,
                          y=lifeExp))

p+geom_point()+geom_smooth(method="gam")+
  scale_x_sqrt(labels=scales::dollar)
  
p+geom_point()+geom_smooth(method="gam")+
  scale_x_reverse(labels=scales::dollar)
#____

rev <- ggplot(data=gapminder,
            mapping=aes(y=gdpPercap,
                        x=lifeExp))

rev+geom_point()+geom_smooth(method="gam")+
  scale_y_log10(labels=scales::dollar)
#--------------------------
yr <- ggplot(data=gapminder,
               mapping=aes(x=gdpPercap,
                           y=lifeExp,
                           color=year,
                           fill=year))
yr+geom_point()+
  geom_smooth(method="loess")+
  scale_x_log10()

#------------------------------
yr1 <- ggplot(data=gapminder,
             mapping=aes(x=gdpPercap,y=lifeExp,color=facto(year))
yr1+geom_point()+
  geom_smooth(method="loess")+
  scale_x_log10(labels=scales::dollar)
#------------------------------


dput(gapminder)
dput(head(gapminder,4))

#line45
#```{r, geoms, echo=FALSE}
#library(ggplot2)
#... + geom_point() # Produces scatterplots
#... + geom_bar() # Bar plots
#.... + geom_boxplot() # boxplots
#... # 
#```


#line110
#```{r, smoothing_methods, eval=TRUE}
#?geom_smooth
#p + geom_point() + geom_smooth() + geom_smooth(method = ...) + geom_smooth(method = ...)
#p + geom_point() + geom_smooth() + geom_smooth(method = ...) + geom_smooth(method = ..., color = "red")
#```



#line131
#```{r, scales, eval=TRUE}
#library(scales)
#p + geom_point() + 
#  geom_smooth(method = "lm") + 
#  scale_x_log10(labels = scales::dollar)
#p + geom_point() + 
#  geom_smooth(method = "lm") + 
#  scale_x_log10(labels = scales::...)
#```


#line183
#```{r, yellow_points, eval=TRUE}
#p <- ggplot(data = gapminder,
#            mapping = aes(x = gdpPercap, y = lifeExp, ...))
#p + geom_point(...) + scale_x_log10()
#```