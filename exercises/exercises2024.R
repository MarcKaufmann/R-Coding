
## And finally (if time permits, which is unlikely):

# What time of the day should you fly to avoid delays the most?

not_missing |>
  mutate(
    hour = ...%/% 100
  ) |>
  group_by(hour) |>
  summarise(
    delay = ...
  ) |>
  mutate(
    rank_delay = ...
  ) |>
  arrange(rank_delay)
