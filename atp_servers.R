library("tidyverse")
library("readr")
library("gt")
# Weighted probability for first serves
data <- read_csv("match data/atp_matches_2022.csv")
# Aggregate winners data
winners_pulled <- data %>%
  select(winner_name, w_svpt, w_1stIn, w_1stWon, w_2ndWon, w_df, w_ace)
winners_renamed <- winners_pulled %>%
  rename(
    player = winner_name,
    first_points = w_svpt,
    first_in = w_1stIn,
    first_won = w_1stWon,
    second_won = w_2ndWon,
    dfs = w_df,
    ace = w_ace
  )
winners <- winners_renamed %>%
  mutate(
    second_points = first_points - first_in,
    second_in = second_points - dfs
  )
# Aggregate losers data
losers_pulled <- data %>%
  select(loser_name, l_svpt, l_1stIn, l_1stWon, l_2ndWon, l_df, l_ace)
losers_renamed <- losers_pulled %>%
  rename(
    player = loser_name,
    first_points = l_svpt,
    first_in = l_1stIn,
    first_won = l_1stWon,
    second_won = l_2ndWon,
    dfs = l_df,
    ace = l_ace
  )
losers <- losers_renamed %>%
  mutate(
    second_points = first_points - first_in,
    second_in = second_points - dfs
  )
# Combine data
combined <- bind_rows(winners, losers) %>%
  filter(!is.na(first_points)) %>%
  group_by(player) %>%
  summarise(
    first_points = sum(first_points),
    first_points_in = sum(first_in),
    first_points_won = sum(first_won),
    second_points = sum(second_points),
    second_points_in = sum(second_in),
    second_points_won = sum(second_won),
    total_dfs = sum(dfs),
    total_aces = sum(ace)
  ) %>%
  filter(first_points > 100)
# Player data frame with serve point averages
players <- combined %>%
  summarise(
    player = player,
    first_serves_in_pct = first_points_in/first_points,
    first_serves_won_pct = first_points_won/first_points_in,
    second_serves_in_pct = second_points_in/second_points,
    second_serves_won_pct = second_points_won/second_points_in
  )
# Data frame with player probabilities for points won
player_probabilities <- players %>%
  summarise(
    player = player,
    likelihood_first_won = first_serves_in_pct * first_serves_won_pct,
    likelihood_second_won = second_serves_in_pct * second_serves_won_pct,
    likelihood_first_missed_second_first_won = (1-first_serves_in_pct) * 
      likelihood_first_won,
    likelihood_first_missed_second_second_won = (1-first_serves_in_pct) * 
      likelihood_second_won,
    likelihood_first_second_missed_second_second_won = (1-second_serves_in_pct) * 
      likelihood_second_won,
    first_weighted = likelihood_first_won + likelihood_first_missed_second_first_won,
    normal_weighted = likelihood_first_won + likelihood_first_missed_second_second_won,
    second_weighted = likelihood_second_won + likelihood_first_second_missed_second_second_won
  )
# x_weighted - meaning the point win probability based on x
# Players who should hit only first serves
first_servers <- player_probabilities %>%
  filter(first_weighted > normal_weighted & first_weighted > second_weighted) %>%
  summarise(Player = player, 
         "Point Win Probability Hitting First Serves" = paste(round(first_weighted, 3) * 100, "%"), 
         "Point Win Probability Hitting Normal Serves" = paste(round(normal_weighted, 3) * 100, "%"), 
         "Point Win Probability Hitting Second Serves" = paste(round(second_weighted, 3) * 100, "%"))
# Players who should hit normal serves
normal_servers <- player_probabilities %>%
  filter(normal_weighted > first_weighted & normal_weighted > second_weighted) %>%
  summarise(Player = player, 
            "Point Win Probability Hitting First Serves" = paste(round(first_weighted, 3) * 100, "%"), 
            "Point Win Probability Hitting Normal Serves" = paste(round(normal_weighted, 3) * 100, "%"), 
            "Point Win Probability Hitting Second Serves" = paste(round(second_weighted, 3) * 100, "%"))
# Players who should hit only second serves
second_servers <- player_probabilities %>%
  filter(second_weighted > first_weighted & second_weighted > normal_weighted) %>%
  summarise(Player = player, 
            "Point Win Probability Hitting First Serves" = paste(round(first_weighted, 3) * 100, "%"), 
            "Point Win Probability Hitting Normal Serves" = paste(round(normal_weighted, 3) * 100, "%"), 
            "Point Win Probability Hitting Second Serves" = paste(round(second_weighted, 3) * 100, "%"))
# Display serve tables
# First servers
first_servers %>%
  gt() %>%
  tab_spanner(
    label = "Players who should hit only First Serves",
    columns = c(Player, `Point Win Probability Hitting First Serves`,
                `Point Win Probability Hitting Normal Serves`,
                `Point Win Probability Hitting Second Serves`)
  ) %>%
  tab_options(table.background.color = "lightblue2") %>%
  cols_align(
    align = c("center"), columns = everything()) %>%
  opt_table_font(font = "Roboto Condensed") %>%
  opt_table_outline() %>%
  tab_source_note(
    source_note = "Jarrett Markman | Data: Jeff Sackmann - GitHub"
  )
# Second servers
second_servers %>%
  gt() %>%
  tab_spanner(
    label = "Players who should hit only Second Serves",
    columns = c(Player, `Point Win Probability Hitting Second Serves`,
                `Point Win Probability Hitting Normal Serves`,
                `Point Win Probability Hitting First Serves`)
  ) %>%
  tab_options(table.background.color = "lightblue2") %>%
  cols_align(
    align = c("center"), columns = everything()) %>%
  opt_table_font(font = "Roboto Condensed") %>%
  opt_table_outline() %>%
  tab_source_note(
    source_note = "Jarrett Markman | Data: Jeff Sackmann - GitHub"
  )
``` {r, echo = FALSE}
# Normal servers
normal_servers %>%
  gt() %>%
  tab_spanner(
    label = "Players who should hit only Normal Serves",
    columns = c(Player, `Point Win Probability Hitting Normal Serves`,
                `Point Win Probability Hitting First Serves`,
                `Point Win Probability Hitting Second Serves`)
  ) %>%
  tab_options(table.background.color = "lightblue2") %>%
  cols_align(
    align = c("center"), columns = everything()) %>%
  opt_table_font(font = "Roboto Condensed") %>%
  opt_table_outline() %>%
  tab_source_note(
    source_note = "Jarrett Markman | Data: Jeff Sackmann - GitHub"
  )
