# Chapter 7 from Data Visualization

library(tidyverse)
# install.packages("socviz")
library(socviz)

election %>%
  select(state, total_vote, r_points, pct_trump, party, census) %>%
  sample_n(5)

party_colors <- c("#2E74C0", "#CB454A") 

p0 <- ggplot(data = filter(election, st %nin% "DC"),
             mapping = aes(x = r_points, 
                           y = reorder(state, r_points), 
                           color = party))

p1 <- p0 + geom_vline(xintercept = 0) +
  geom_point(size = 2)
p1

p2 <- p1 + scale_color_manual(values = party_colors)
p2

p3 <- p2 + facet_wrap(~ census, ncol = 1, scales = "free_y") +
  guides(color = FALSE) + 
  labs(y = "", x = "Point Margin") + 
  theme(axis.text=element_text(size=8))
p3

library(maps)
us_states <- map_data("state")
head(us_states)
?geom_polygon

us_states %>% 
  ggplot(mapping = aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black")

us_states %>% 
  ggplot(mapping = aes(x = long, 
                       y = lat, 
                       group = group,
                       fill = region)) +
  geom_polygon(color = "gray90", size = 0.1) + 
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  guides(fill = FALSE)

# Join map data with election data
(election$region <- tolower(election$state))
as_tibble(us_states)
election
anti_join(us_states, election)
(us_states_election <- us_states %>% 
  left_join(election) %>%
  as_tibble())

p_pct_dem <- us_states_election %>%
  filter(region %nin% "district of columbia") %>%
  ggplot(aes(x = long, 
             y = lat, 
             group = group,
             fill = d_points))

p_pct_trump <- us_states_election %>%
  filter(region %nin% "district of columbia") %>%
  ggplot(aes(x = long, 
             y = lat, 
             group = group,
             fill = pct_trump))

p_pct_trump +
  # How does ggplot know how to change the color of the states?
  geom_polygon(color = "gray90", size = 0.1) + 
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  labs(title = "Republican vote 2016", fill = "Percent")

# This does not do what I expected
p_pct_trump +
  geom_polygon(color = "gray90", size = 0.1) + 
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white") +
  labs(title = "Republican vote 2016", fill = "Percent")

# This does
p_pct_dem +
  geom_polygon(color = "gray90", size = 0.1) + 
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  scale_fill_gradient2(low = "red", high = "blue", mid = "white") +
  labs(title = "Democrat vote 2016", fill = "Percent")

ggplot(data = filter(us_states_election,
                     region %nin% "district of columbia"),
       aes(x = long, 
           y = lat, 
           group = group,
           fill = d_points)) +
  geom_polygon(color = "gray90", size = 0.1) + 
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  scale_fill_gradient2(low = "red", high = "blue", mid = scales::muted("purple")) +
  labs(title = "Democrat vote 2016", fill = "Percent")

# Chapter 7, part 4 of socviz.co

library(socviz)
library(maps)
# Make sure you have the package mapproj installed

# Join opiates with states
opiates
opiates <- opiates %>% 
  mutate(region = tolower(state)) %>%
  as_tibble()
(us_states <- as_tibble(us_states))
# Check all us_states match
anti_join(us_states, opiates)
(opiates_map <- as_tibble(left_join(us_states, opiates)))
# Why does this map have so many rows?

opiates_map <- opiates_map %>%
  mutate(prop_deaths = deaths / population * 100000)

# Draw the map for a single year
opiates2000 <- opiates_map %>% filter(year == 2000)

# Build it one step at a time

ggplot(opiates2000,
       aes(x = long, 
           y = lat,
           group = group,
           fill = adjusted)) +
  scale_fill_gradient(low = "dark blue", high = "yellow") +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  geom_polygon() +
  theme(legend.position = "bottom",
        strip.background = element_blank()) +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank()) +
  labs(fill = "Deaths per 100,000", x = "", y = "") 

ggplot(opiates_map,
       aes(x = long, 
           y = lat,
           group = group,
           fill = adjusted)) +
  scale_fill_gradient(low = "dark blue", high = "yellow") +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  geom_polygon() +
  facet_wrap(~ year) +
  theme(legend.position = "bottom",
        strip.background = element_blank()) +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank()) +
  labs(fill = "Deaths per 100,000", x = "", y = "") 

# Plot all the lines over time for states

p1 <- ggplot(drop_na(opiates, division_name, state, adjusted),
       aes(x = year,
           y = adjusted,
           group = state)) + 
  geom_line(color = "gray70")
p1

(p2 <- p1 + 
  geom_smooth(mapping = aes(group = division_name), se = FALSE))
# What's with the error messages?

library(ggrepel)
(p3 <- p2 + 
    geom_text_repel(data = filter(opiates,
                                  year == max(year),
                                  abbr != "DC"),
                    mapping = aes(x = year, y = adjusted, label = abbr),
                    size = 1.8, segment.color = NA, nudge_x = 30))

# Split next into two
(p4 <- p3 + 
    facet_wrap(~reorder(division_name, -adjusted, na.rm = TRUE)))
