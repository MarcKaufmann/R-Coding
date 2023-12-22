# Lecture 12
# Based on Chapter 7 from Healy's "Data Visualization"

library(tidyverse)
library(socviz)
library(mapproj)

election
party_colors <- c("#2E74C0", "#CB454A")

(p0 <- ggplot(
  data = filter(election, st %nin% "DC"),
  mapping = aes(x = r_points,
                y = reorder(state, r_points),
                color = party)))

(p1 <- p0 + 
    geom_vline(xintercept = 0) +
    geom_point(size = 2))

(p2 <- p1 + scale_color_manual(values = party_colors))

(p3 <- p2 +
  facet_wrap(~ census, ncol = 1, scales = "free_y") +
  guides(color = FALSE) +
  labs(y = "", x = "Point Margin") + 
  theme(axis.text = element_text(size = 8)))

# Let's visualize this on a map
library(maps)
us_states <- map_data("state")
head(us_states)

?geom_polygon
us_states |> 
  ggplot(aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black")

us_states |>
  ggplot(aes(x = long, y = lat, group = group, fill = region)) +
  geom_polygon(color = "gray90", size = 0.1) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  guides(fill = FALSE)

(election$region <- tolower(election$state))
anti_join(us_states, election)

us_states_election <- us_states |>
  left_join(election) |>
  as_tibble()

(p_pct_trump <- us_states_election |>
  filter(region %nin% "district of columbia") |>
  ggplot(aes(x = long, y = lat, group = group, fill = pct_trump)) +
  geom_polygon(color = "gray90", size = 0.1) +
    coord_map(projection = "albers", lat0 = 39, lat1 = 45) + 
    labs(title = "Republican vote 2016", fill = "Percent"))
    
(p_pct_trump <- us_states_election |>
  filter(region %nin% "district of columbia") |>
  ggplot(aes(x = long, y = lat, group = group, fill = pct_trump)) +
  geom_polygon(color = "gray90", size = 0.1) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) + 
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 48) +
  labs(title = "Republican vote 2016", fill = "Percent"))

(p_pct_trump <- us_states_election |>
  filter(region %nin% "district of columbia") |>
  ggplot(aes(x = long, y = lat, group = group, fill = pct_trump)) +
  geom_polygon(color = "gray90", size = 0.1) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) + 
  scale_fill_gradient2(low = "blue", high = "red", mid = scales::muted("purple"), midpoint = 48) +
  labs(title = "Republican vote 2016", fill = "Percent"))


# Chapter 7, part 4 of socviz.co

opiates
opiates <- opiates |>
  mutate(region = tolower(state)) |>
  as_tibble()
# Check all us_states have a match
anti_join(us_states, opiates)
(opiates_map <- as_tibble(left_join(us_states, opiates)))

opiates_map <- opiates_map |>
  mutate(prop_deaths = 100000 * deaths / population)

# Draw the map for a single year
opiates2000 <- opiates_map |> filter(year == 2000)

ggplot(opiates2000,
       aes(x = long, y = lat, group = group, fill = prop_deaths)) +
  geom_polygon() +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  scale_fill_gradient(low = "dark blue", high = "yellow") + 
  labs(fill = "Deaths per 100,000", x = "", y = "")

ggplot(opiates_map,
       aes(x = long, y = lat, group = group, fill = prop_deaths)) +
  geom_polygon() +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  scale_fill_gradient(low = "dark blue", high = "yellow") + 
  labs(fill = "Deaths per 100,000", x = "", y = "") +
  facet_wrap(~ year)

(p1 <- ggplot(drop_na(opiates, division_name, state, adjusted),
             aes(x = year, y = adjusted, group = state)) +
  geom_line(color = "gray70"))

(p2 <- p1 + 
    geom_smooth(aes(group = division_name), se = FALSE))

library(ggrepel)
(p3 <- p2 +
    geom_text_repel(data = filter(opiates,
                                  year == max(year),
                                  abbr != "DC"),
                    aes(x = year, y = adjusted, label = abbr),
                    size = 1.8))

(p4 <- p3 +
  facet_wrap(~ reorder(division_name, -adjusted, na.rm = TRUE)))

unique(opiates$year)
