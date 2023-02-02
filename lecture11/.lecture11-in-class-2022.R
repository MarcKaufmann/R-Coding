# Lecture 11, in class

# Chapter 7 from /Data Visualization/

library(tidyverse)
# install.packages("socviz")
library(socviz)

election %>%
  select(state, total_vote, r_points, pct_trump, party, census) %>%
  sample_n(5)
?election

party_colors <- c("#2E74C0", "#CB454A")

# Plot the vote share of republicans by state
p0 <- ggplot(
  data = filter(election, st %nin% "DC"),
  mapping = aes(x = r_points, 
                y = reorder(state, r_points),
                color = party))

p1 <- p0 + 
  geom_vline(xintercept = 0) + 
  geom_point(size = 2)
p1  

p2 <- p1 + scale_color_manual(values = party_colors)
p2

# Does this differ by census region?
(p3 <- p2 + facet_wrap(~ census, ncol = 1, scales = "free_y")) + 
  guides(color = FALSE) + 
  labs(y = "", x = "Point Margin") + 
  theme(axis.text=element_text(size = 8))

# Let's visualize with maps
library(maps)
us_states <- map_data("state")
head(us_states)
?geom_polygon

us_states %>%
  ggplot(mapping = aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black")

us_states %>%
  ggplot(mapping = aes(x = long, y = lat, group = group, fill = region)) +
  geom_polygon(color = "gray90", size = 0.1) + 
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) + 
  guides(fill = FALSE)

(election$region <- tolower(election$state))
as_tibble(us_states)
election %>% select(region, everything())
anti_join(us_states, election)
(us_states_election <- us_states %>%
    left_join(election) %>%
    as_tibble())

(p_pct_dem <- us_states_election %>%
  filter(region %nin% "district of columbia") %>%
  ggplot(
    aes(x = long, y = lat, group = group, fill = d_points)
  ))

p_pct_trump <- us_states_election %>%
  filter(region %nin% "district of columbia") %>%
  ggplot(
    aes(x = long,
        y = lat,
        group = group,
        fill = pct_trump)
  )

p_pct_trump + 
  geom_polygon(color = "gray90", size = 0.1) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  labs(title = "Republican vote 2016", fill = "Percent")

p_pct_trump + 
  geom_polygon(color = "gray90", size = 0.1) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white") +
  labs(title = "Republican vote 2016", fill = "Percent")

p_pct_dem + 
  geom_polygon(color = "gray90", size = 0.1) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  scale_fill_gradient2(low = "red", high = "blue", mid = scales::muted("purple")) +
  labs(title = "Democrat vote 2016", fill = "Percent")


# Leaving elections, moving to opioid crisis
opiates
opiates <- opiates %>%
  mutate(region = tolower(state)) %>%
  as_tibble()
(us_states <- as_tibble(us_states))
# Check that all states match
anti_join(us_states, opiates)
(opiates_map <- left_join(us_states, opiates))

opiates_map <- opiates_map %>%
  mutate(prop_deaths = 100000 * deaths / population)

opiates2000 <- opiates_map %>% filter(year == 2000)

ggplot(opiates2000,
       aes(x = long, y = lat, group = group, fill = prop_deaths)) +
  scale_fill_gradient(low = "dark blue", high = "yellow") +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  theme(legend.position = "bottom") +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank()) +
  geom_polygon() + 
  labs(x = "", y = "", fill = "Deaths per 100,000")

ggplot(opiates_map,
       aes(x = long, y = lat, group = group, fill = prop_deaths)) +
  scale_fill_gradient(low = "dark blue", high = "yellow") +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  theme(legend.position = "bottom") +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank()) +
  geom_polygon() + 
  facet_wrap(~ year) +
  labs(x = "", y = "", fill = "Deaths per 100,000")
  
  # Plot the number of deaths over time for states
  
p1 <- ggplot(drop_na(opiates, division_name, state, adjusted), 
             aes(x = year, 
                 y = adjusted,
                 group = state)) +
  geom_line(color = "gray70")
p1    

(p2 <- p1 + 
    geom_smooth(mapping = aes(group = division_name), se = FALSE))

p3 <- p2 + 
  facet_wrap(~ reorder(division_name, -adjusted, na.rm = TRUE))
p3

library(ggrepel)
p4 <- p3 + 
  geom_text_repel(data = filter(opiates, 
                                year == max(year),
                                abbr != "DC"),
                  mapping = aes(x = year, y = adjusted, label = abbr))
p4

p5 <- p2 +
  geom_text_repel(data = filter(opiates, 
                                year == max(year),
                                abbr != "DC"),
                  mapping = aes(x = year, y = adjusted, label = abbr),
                  size = 1.8, segment.color = NA, nudge_x = 30)
p5

p6 <- p5 + 
  facet_wrap(~ reorder(division_name, -adjusted, na.rm = TRUE))
p6
