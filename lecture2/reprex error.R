
library(gapminder)
library(ggplot2)
library(scales)

gap_data <- structure(list(country = structure(c(1L, 1L, 1L, 1L, 1L, 1L), .Label = c("Afghanistan", 
"Albania", "Algeria", "Angola", "Argentina", "Australia", "Austria", 
"Bahrain", "Bangladesh", "Belgium", "Benin", "Bolivia", "Bosnia and Herzegovina", 
"Botswana", "Brazil", "Bulgaria", "Burkina Faso", "Burundi", 
"Cambodia", "Cameroon", "Canada", "Central African Republic", 
"Chad", "Chile", "China", "Colombia", "Comoros", "Congo, Dem. Rep.", 
"Congo, Rep.", "Costa Rica", "Cote d'Ivoire", "Croatia", "Cuba", 
"Czech Republic", "Denmark", "Djibouti", "Dominican Republic", 
"Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", 
"Ethiopia", "Finland", "France", "Gabon", "Gambia", "Germany", 
"Ghana", "Greece", "Guatemala", "Guinea", "Guinea-Bissau", "Haiti", 
"Honduras", "Hong Kong, China", "Hungary", "Iceland", "India", 
"Indonesia", "Iran", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", 
"Japan", "Jordan", "Kenya", "Korea, Dem. Rep.", "Korea, Rep.", 
"Kuwait", "Lebanon", "Lesotho", "Liberia", "Libya", "Madagascar", 
"Malawi", "Malaysia", "Mali", "Mauritania", "Mauritius", "Mexico", 
"Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar", 
"Namibia", "Nepal", "Netherlands", "New Zealand", "Nicaragua", 
"Niger", "Nigeria", "Norway", "Oman", "Pakistan", "Panama", "Paraguay", 
"Peru", "Philippines", "Poland", "Portugal", "Puerto Rico", "Reunion", 
"Romania", "Rwanda", "Sao Tome and Principe", "Saudi Arabia", 
"Senegal", "Serbia", "Sierra Leone", "Singapore", "Slovak Republic", 
"Slovenia", "Somalia", "South Africa", "Spain", "Sri Lanka", 
"Sudan", "Swaziland", "Sweden", "Switzerland", "Syria", "Taiwan", 
"Tanzania", "Thailand", "Togo", "Trinidad and Tobago", "Tunisia", 
"Turkey", "Uganda", "United Kingdom", "United States", "Uruguay", 
"Venezuela", "Vietnam", "West Bank and Gaza", "Yemen, Rep.", 
"Zambia", "Zimbabwe"), class = "factor"), continent = structure(c(3L, 
3L, 3L, 3L, 3L, 3L), .Label = c("Africa", "Americas", "Asia", 
"Europe", "Oceania"), class = "factor"), year = c(1952L, 1957L, 
1962L, 1967L, 1972L, 1977L), lifeExp = c(28.801, 30.332, 31.997, 
34.02, 36.088, 38.438), pop = c(8425333L, 9240934L, 10267083L, 
11537966L, 13079460L, 14880372L), gdpPercap = c(779.4453145, 
820.8530296, 853.10071, 836.1971382, 739.9811058, 786.11336)), class = c("tbl_df", 
"tbl", "data.frame"), row.names = c(NA, -6L))

p <- ggplot(gap_data, aes(year, gdpPercap, size = pop, color = continent))

p + geom_histogram(stroke = 100) + 
  scale_y_log10(labels = scales::comma) + 
  scale_radius(labels = scales::comma) + 
  labs(y = "GDP Per Capita", Time = "Life Expectancy in Years",
       title = "Economic Growth over Time",
       subtitle = "Data Points are different countries",
       caption = "Source: Gapminder.", size = "Population in Millions")

