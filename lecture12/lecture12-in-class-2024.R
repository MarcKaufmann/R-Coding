library(tidyverse)
library(socviz)
library(mapproj)

# Follows Chapter 7 of Data Visualization by Healy

election 
  
party_colors <- c("#2E74C0", "#CB454A")

p0 <- ggplot(data = filter(election, st %nin% "DC"),
             mapping = aes(x = r_points,
                           y = reorder(state, r_points),
                           color = party))

(p1 <- p0 + geom_vline(xintercept = 0) + 
    geom_point(size = 2))

(p2 <- p1 + scale_color_manual(values = party_colors))

# Doing it by census region
(p3 <- p2 + facet_wrap(~ census, ncol = 1, scales = "free_y" ))

# Visualizing it on a map
library(maps)
us_states <- map_data("state")
head(us_states)
?geom_polygon

us_states |>
  ggplot(mapping = aes(
    x = long, 
    y = lat, 
    group = group,
    fill = region
    )) + 
  geom_polygon(color = "gray90", size = 0.1) + 
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) + 
  guides(fill = FALSE)
  
head(us_states)
(election$region <- tolower(election$state))

anti_join(us_states, election)

us_states_election <- us_states |>
  left_join(election) |>
  as_tibble()

p_pct_dem <- us_states_election |>
  filter(region %nin% "district of columbia") |>
  ggplot(aes(
    x = long,
    y = lat,
    fill = d_points,
    group = group
    ))

p_pct_trump <- us_states_election |>
  filter(region %nin% "district of columbia") |>
  ggplot(aes(
    x = long,
    y = lat,
    group = group,
    fill = pct_trump
  ))

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
  
# Join opiates
opiates

opiates <- opiates |>
  mutate(region = tolower(state)) |>
  as_tibble()

anti_join(us_states, opiates)
(us_states <- as_tibble(us_states))

(opiates_map <- left_join(us_states, opiates))
opiates

opiates_map <- opiates_map |>
  mutate(prop_deaths = (deaths / population) * 100000 )

opiates2000 <- opiates_map |> filter(year == 2000)

ggplot(opiates2000,
       aes(x = long,
           y = lat,
           group = group,
           fill = prop_deaths)) +
  geom_polygon(color = "gray90", size = 0.1) + 
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  scale_fill_gradient(low = "dark blue", high = "yellow") +
  theme(legend.position = "bottom",
        strip.background = element_blank()) +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank()) +
  labs(title = "Opiates Deaths", fill = "Deaths per 100,000")

ggplot(opiates_map,
       aes(x = long,
           y = lat,
           group = group,
           fill = prop_deaths)) +
  geom_polygon(color = "gray90", size = 0.1) + 
  facet_wrap(~ year) +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  scale_fill_gradient(low = "dark blue", high = "yellow") +
  theme(legend.position = "bottom",
        strip.background = element_blank()) +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank()) +
  labs(title = "Opiates Deaths", fill = "Deaths per 100,000")
