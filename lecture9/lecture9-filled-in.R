# Lecture 9

library(modelr)
library(ggplot2)
library(tidyverse)

sim1
sim1_mod <- lm(y ~ x, data = sim1)
sim1_mod
summary(sim1_mod)
sim1_mod_no_intercept <- lm(y ~ x - 1, data = sim1)
sim1_mod_no_intercept
coef(sim1_mod)[2]
str(sim1_mod)
sim1_mod$coefficients
sim1_not_square <- lm(y ~ x + x*x, data = sim1)
sim1_not_square
sim1_square <- lm(y ~ x + I(x*x), data = sim1)
sim1_square
sim1b <- sim1 %>%
  mutate(sq = x*x) # Can I pass with pipe to second (or third...) argument?
lm(y ~ x + sq, data = sim1b)


# Add predictions and residuals, defined in modelr
library(broom)

(df <- augment(sim1_mod))

ggplot(df, aes(x, y)) + 
  geom_point() + 
  geom_point(mapping = aes(y = .fitted), color = "red") + 
  geom_abline(aes(
    intercept = coef(sim1_mod)[1],
    slope = coef(sim1_mod)[2]
  ), color = "red") +
  geom_smooth(mapping = aes(y = .fitted), method = "lm", color = "yellow")

# Residuals next
df %>%
  mutate(sq = x*x) %>%
  ggplot(aes(sq, .resid)) + 
  geom_point()

# Base R
(df <- df %>%
    mutate(
      pred2 = predict(sim1_mod),
      resid2 = residuals(sim1_mod)
    ))

# Richer linear models
sim3
ggplot(sim3, aes(x1, y, color = x2)) + 
  geom_point()

mod1 <- lm(y ~ x1 + x2, data = sim3)
mod2 <- lm(y ~ x1*x2, data = sim3)
mod2b <- lm(y ~ x1 + x2 + x1:x2, data = sim3)

mod2
mod2b

sim3 <- modelr::sim3 |>
  mutate(
    mod1 = augment(mod1)$.fitted,
    mod2 = augment(mod2)$.fitted
  )
sim3

sim3 |>
  ggplot(aes(x = x1, y = y, color = x2)) + 
  geom_point() + 
  geom_line(aes(y = mod1))

sim3 |>
  ggplot(aes(x = x1, y = y, color = x2)) + 
  geom_point() + 
  geom_line(aes(y = mod2))

# Functions, iterations, conditionals and all that
square_func <- function(x) {
  #x + x
  #x*3
  #print("I have computed it.")
  x*x
}

square_func(2)
square_func(4)

cube_func <- function(x) x^3
cube_func(4)

# Would not really work:
# quartic_func <- function(x) 
#    x*2
#    x^4
# quartic_func(4)

cube_func <- function(my_silly_name) {
  my_silly_name^3
}
cube_func(3)

sqrt(2)
sqrt(-2)
my_sqrt <- function(x) {
  if (x < 0) {
    "not allowed"
  } else {
    sqrt(x)
  }
}
my_sqrt(2)
my_sqrt(-2)

# When working with random numbers, use set.seed() to make code replicable
set.seed(42)
runif(10)
set.seed(42)
runif(10)

# Iterations and reasons from Data Report 2


mean_scores <- tribble(
  ~tpc, ~overall_mean,
  "AI", 4,
  "Addiction", 5,
  "Neuroscience", 3
)

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

overall_mean_reasons <- add_overall_mean_reason(mean_scores)

reason_sentence <- function(t, m) {
  paste0(
      "The topic '", 
      t , 
      "' has a high overall mean score of ", 
      m, 
      ", indicating positive reception."
    )
}

mean_reasons <- mean_scores |>
  mutate(
    reasons = reason_sentence(tpc, overall_mean),
    reason_dir = if_else( overall_mean > mean(overall_mean, na.rm = T), "for", "against" )
  )

# Now on to Broom from Chapter 6.5 of DV by Healy
library(broom)

out <- lm(formula = lifeExp ~ gdpPercap + pop + continent, data = gapminder::gapminder)
summary(out)

out_comp <- tidy(out)

# Book uses round_df, requires new package, decided to roll my own
round_df <- function(df) {
  df |>
    mutate(
      # Looked up ?across, found example
      across(where(is.numeric), ~ round(.x, digits = 2))
    )
}

out_comp |> 
  round_df()

p <- ggplot(out_comp, mapping = aes(x = term, y = estimate))

p + geom_point() + coord_flip()

out_conf <- tidy(out, conf.int = TRUE)
out_conf |> round_df()

p <- ggplot(
  out_conf |> filter(term != "(Intercept)"),
  mapping = aes(x = term, y = estimate, ymin = conf.low, ymax = conf.high)
)

p + geom_pointrange() + coord_flip() + labs(x = "", y = "OLS Estimate")

# Rearrange by size of estimate
p <- ggplot(
  out_conf |> filter(term != "(Intercept)"),
  mapping = aes(x = reorder(term, estimate), y = estimate, ymin = conf.low, ymax = conf.high)
)

p + geom_pointrange() + coord_flip() + labs(x = "", y = "OLS Estimate")

# Plot predicted data
out_aug <- augment(out)
head(out_aug) |> round_df()

out_aug <- augment(out, data = gapminder::gapminder)
head(out_aug) |> round_df()

# Is this a good model? Is any structure left in the residuals?
p <- ggplot(data = out_aug, mapping = aes(x = .fitted, y = .resid))
p + geom_point()

# Final command of package broom: glance
glance(out) |> round_df()
