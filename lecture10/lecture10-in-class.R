# Lecture 10: data reports 3 and 4

# Iterations and reasons from Data Report 2

(mean_scores <- tribble(
  ~tpc, ~overall_mean,
  "AI", 4,
  "Addiction", 5,
  "Neuroscience", 3
))

x <- c()
y <- 1
for (i in mean_scores) {
  print(list(item=i, count=y))
  y <- y + 1
}
?seq_along


add_overall_mean_reason <- function(overall_mean_scores) {
  reasons <- data.frame(topic = character(), reason_direction = character(), reason = character(), strength_of_reason = numeric())
  for (i in 1:nrow(overall_mean_scores)) {
    row <- overall_mean_scores[i, ]
    topic <- row$tpc
    overall_mean <- row$overall_mean

    if (overall_mean >= mean(overall_mean_scores$overall_mean, na.rm = TRUE)) {
      reasons <- rbind(reasons, data.frame(topic, reason_direction = "for", reason = paste0("The topic '", topic, "' has a high overall mean score of ", overall_mean, ", indicating positive reception."), strength_of_reason = 5))
    } else {
      reasons <- rbind(reasons, data.frame(topic, reason_direction = "against", reason = paste0("The topic '", topic, "' has a low overall mean score of ", overall_mean, ", indicating less positive reception."), strength_of_reason = 3))
    }
  }
  
  return(reasons)
}

overall_mean_reasons <- as_tibble(add_overall_mean_reason(mean_scores))
overall_mean_reasons

reason_sentence <- function(t, rd, m) {
  paste0(
      "The topic ",
      t,
      " has a ",
      if_else( rd == "for", "high", "low"),
      " overall mean score of ",
      m)
}

(mean_reasons <- mean_scores |>
  mutate(
    reason_dir = if_else(overall_mean >= mean(overall_mean, na.rm = TRUE) ,
                         "for", 
                         "against"),
    reason = reason_sentence(tpc, reason_dir, overall_mean)
  ))
