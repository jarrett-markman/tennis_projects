library(tidyverse)
# Load in all the data sets
data10 <- read_csv("atp_matches_2010.csv")
data11 <- read_csv("atp_matches_2011.csv")
data12 <- read_csv("atp_matches_2012.csv")
data13 <- read_csv("atp_matches_2013.csv")
data14 <- read_csv("atp_matches_2014.csv")
data15 <- read_csv("atp_matches_2015.csv")
data16 <- read_csv("atp_matches_2016.csv")
data17 <- read_csv("atp_matches_2017.csv")
data18 <- read_csv("atp_matches_2018.csv")
data19 <- read_csv("atp_matches_2019.csv")
data <- bind_rows(data10, data11, data12, data13, data14, data15, data16, data17, data18, data19) %>%
  mutate(year = substring(tourney_date, 1, 4)) # Use substring command to take the first 4 values from tourney_date and store them into "year"
novak_wins <- data %>%
  filter(winner_name == "Novak Djokovic") %>% # Filter winner_name equal to Novak
  rename( # Rename the variables from wins into general variable names
    player_id = winner_id,
    seed = winner_seed,
    player_entry = winner_entry,
    player = winner_name,
    hand = winner_hand,
    height = winner_ht,
    country = winner_ioc,
    age = winner_age,
    aces = w_ace,
    dfs = w_df,
    first_serve_points = w_svpt,
    first_in = w_1stIn,
    first_won = w_1stWon,
    second_won = w_2ndWon,
    serve_games = w_SvGms,
    break_points_saved = w_bpSaved,
    break_points = w_bpFaced,
    rank = winner_rank,
    rank_points = winner_rank_points,
    opp_player_id = loser_id,
    opp_seed = loser_seed,
    opp_player_entry = loser_entry,
    opp_player = loser_name,
    opp_hand = loser_hand,
    opp_height = loser_ht,
    opp_country = loser_ioc,
    opp_age = loser_age,
    opp_aces = l_ace,
    opp_dfs = l_df,
    opp_first_serve_points = l_svpt,
    opp_first_in = l_1stIn,
    opp_first_won = l_1stWon,
    opp_second_won = l_2ndWon,
    opp_serve_games = l_SvGms,
    opp_break_points_saved = l_bpSaved,
    opp_break_points = l_bpFaced,
    opp_rank = loser_rank,
    opp_rank_points = loser_rank_points
  ) %>%
  mutate(
    second_serve_points = first_serve_points - first_in,
    second_in = second_serve_points - dfs,
    opp_second_serve_points = opp_first_serve_points - opp_first_in,
    opp_second_in = opp_second_serve_points - opp_dfs
  )
novak_losses <- data %>%
  filter(loser_name == "Novak Djokovic") %>% # Filter loser_name equal to Novak
  rename( # Rename and change all the columns in losses to the same variable names as wins
    opp_player_id = winner_id,
    opp_seed = winner_seed,
    opp_player_entry = winner_entry,
    opp_player = winner_name,
    opp_hand = winner_hand,
    opp_height = winner_ht,
    opp_country = winner_ioc,
    opp_age = winner_age,
    opp_aces = w_ace,
    opp_dfs = w_df,
    opp_first_serve_points = w_svpt,
    opp_first_in = w_1stIn,
    opp_first_won = w_1stWon,
    opp_second_won = w_2ndWon,
    opp_serve_games = w_SvGms,
    opp_break_points_saved = w_bpSaved,
    opp_break_points = w_bpFaced,
    opp_rank = winner_rank,
    opp_rank_points = winner_rank_points,
    player_id = loser_id,
    seed = loser_seed,
    player_entry = loser_entry,
    player = loser_name,
    hand = loser_hand,
    height = loser_ht,
    country = loser_ioc,
    age = loser_age,
    aces = l_ace,
    dfs = l_df,
    first_serve_points = l_svpt,
    first_in = l_1stIn,
    first_won = l_1stWon,
    second_won = l_2ndWon,
    serve_games = l_SvGms,
    break_points_saved = l_bpSaved,
    break_points = l_bpFaced,
    rank = loser_rank,
    rank_points = loser_rank_points
  ) %>%
  mutate( # Use the mutate command to create additional data characteristics
    second_serve_points = first_serve_points - first_in,
    second_in = second_serve_points - dfs,
    opp_second_serve_points = opp_first_serve_points - opp_first_in,
    opp_second_in = opp_second_serve_points - opp_dfs
  )
novak <- bind_rows(novak_wins, novak_losses)
novak_stats <- novak %>%
  filter(!is.na(first_serve_points)) %>% # Use the filter command and !is.na to chose the non-na values
  group_by(player) %>% # Group by the "player" variable
  summarise(total_aces = sum(aces),
            total_dfs = sum(dfs),
            total_serve_points = sum(first_serve_points),
            first_serves_in = sum(first_in),
            first_serves_won = sum(first_won),
            total_second_points = sum(second_serve_points),
            second_serves_in = sum(second_in),
            second_serves_won = sum(second_won),
            total_service_games = sum(serve_games),
            total_service_bp_saved = sum(break_points_saved),
            total_service_bps = sum(break_points),
            service_games_played = total_service_games,
            service_games_lost = total_service_bps - total_service_bp_saved,
            service_games_won = service_games_played - service_games_lost,
            opp_total_aces = sum(opp_aces),
            opp_total_dfs = sum(opp_dfs),
            opp_total_serve_points = sum(opp_first_serve_points),
            opp_first_serves_in = sum(opp_first_in),
            opp_first_serves_won = sum(opp_first_won),
            opp_total_second_points = sum(opp_second_serve_points),
            opp_second_serves_in = sum(opp_second_in),
            opp_second_serves_won = sum(opp_second_won),
            opp_total_service_games = sum(opp_serve_games),
            opp_total_service_bp_saved = sum(opp_break_points_saved),
            opp_total_service_bps = sum(opp_break_points),
            opp_service_games_played = opp_total_service_games,
            opp_service_games_lost = opp_total_service_bps - opp_total_service_bp_saved,
            opp_service_games_won = opp_service_games_played - opp_service_games_lost,
            avg_rank = mean(rank),
            avg_opp_rank = mean(opp_rank)
          )
# Plots
novak_wins %>%
  mutate(p1_first_in_pct = first_in/first_serve_points) %>% # Use "mutate" to create a new column to calculate first serve percentage 
  # Make a histogram for first serve percentage
  ggplot(aes(x = p1_first_in_pct)) + 
  geom_histogram(colour = "black", fill = "blue") +
  labs(
    x = "First Serve In Pct",
    y = "Frequency",
    title = "Novak Djokovic First Serve Percentage in Match Wins"
  ) +
  xlim(.4, 1) +
  theme_bw() +
  theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5))
novak_losses %>%
  mutate(p1_first_in_pct = first_in/first_serve_points) %>%
  ggplot(aes(x = p1_first_in_pct)) +
  geom_histogram(colour = "black", fill = "red") +
  labs(
    x = "First Serve In Pct",
    y = "Frequency",
    title = "Novak Djokovic First Serve Percentage in Match Losses"
  ) +
  xlim(.4, 1) +
  theme_bw() +
  theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5))
# Change data into winners and losses
winners <- data %>%
  rename(
    player_id = winner_id,
    seed = winner_seed,
    player_entry = winner_entry,
    player = winner_name,
    hand = winner_hand,
    height = winner_ht,
    country = winner_ioc,
    age = winner_age,
    aces = w_ace,
    dfs = w_df,
    first_serve_points = w_svpt,
    first_in = w_1stIn,
    first_won = w_1stWon,
    second_won = w_2ndWon,
    serve_games = w_SvGms,
    break_points_saved = w_bpSaved,
    break_points = w_bpFaced,
    rank = winner_rank,
    rank_points = winner_rank_points,
    opp_player_id = loser_id,
    opp_seed = loser_seed,
    opp_player_entry = loser_entry,
    opp_player = loser_name,
    opp_hand = loser_hand,
    opp_height = loser_ht,
    opp_country = loser_ioc,
    opp_age = loser_age,
    opp_aces = l_ace,
    opp_dfs = l_df,
    opp_first_serve_points = l_svpt,
    opp_first_in = l_1stIn,
    opp_first_won = l_1stWon,
    opp_second_won = l_2ndWon,
    opp_serve_games = l_SvGms,
    opp_break_points_saved = l_bpSaved,
    opp_break_points = l_bpFaced,
    opp_rank = loser_rank,
    opp_rank_points = loser_rank_points
  ) %>%
  mutate(
    second_serve_points = first_serve_points - first_in,
    second_in = second_serve_points - dfs,
    opp_second_serve_points = opp_first_serve_points - opp_first_in,
    opp_second_in = opp_second_serve_points - opp_dfs
  )
losers <- data %>%
  rename(
    opp_player_id = winner_id,
    opp_seed = winner_seed,
    opp_player_entry = winner_entry,
    opp_player = winner_name,
    opp_hand = winner_hand,
    opp_height = winner_ht,
    opp_country = winner_ioc,
    opp_age = winner_age,
    opp_aces = w_ace,
    opp_dfs = w_df,
    opp_first_serve_points = w_svpt,
    opp_first_in = w_1stIn,
    opp_first_won = w_1stWon,
    opp_second_won = w_2ndWon,
    opp_serve_games = w_SvGms,
    opp_break_points_saved = w_bpSaved,
    opp_break_points = w_bpFaced,
    opp_rank = winner_rank,
    opp_rank_points = winner_rank_points,
    player_id = loser_id,
    seed = loser_seed,
    player_entry = loser_entry,
    player = loser_name,
    hand = loser_hand,
    height = loser_ht,
    country = loser_ioc,
    age = loser_age,
    aces = l_ace,
    dfs = l_df,
    first_serve_points = l_svpt,
    first_in = l_1stIn,
    first_won = l_1stWon,
    second_won = l_2ndWon,
    serve_games = l_SvGms,
    break_points_saved = l_bpSaved,
    break_points = l_bpFaced,
    rank = loser_rank,
    rank_points = loser_rank_points
  ) %>%
  mutate(
    second_serve_points = first_serve_points - first_in,
    second_in = second_serve_points - dfs,
    opp_second_serve_points = opp_first_serve_points - opp_first_in,
    opp_second_in = opp_second_serve_points - opp_dfs
  )
all_data <- bind_rows(winners, losers) %>%
  filter(!is.na(first_serve_points))
player_stats <- all_data %>%
  group_by(player) %>%
  summarise(
    total_aces = sum(aces),
    total_dfs = sum(dfs),
    total_serve_points = sum(first_serve_points),
    first_serves_in = sum(first_in),
    first_serves_won = sum(first_won),
    total_second_points = sum(second_serve_points),
    second_serves_in = sum(second_in),
    second_serves_won = sum(second_won),
    total_service_games = sum(serve_games),
    total_service_bp_saved = sum(break_points_saved),
    total_service_bps = sum(break_points),
    service_games_played = total_service_games,
    service_games_lost = total_service_bps - total_service_bp_saved,
    service_games_won = service_games_played - service_games_lost,
    opp_total_aces = sum(opp_aces),
    opp_total_dfs = sum(opp_dfs),
    opp_total_serve_points = sum(opp_first_serve_points),
    opp_first_serves_in = sum(opp_first_in),
    opp_first_serves_won = sum(opp_first_won),
    opp_total_second_points = sum(opp_second_serve_points),
    opp_second_serves_in = sum(opp_second_in),
    opp_second_serves_won = sum(opp_second_won),
    opp_total_service_games = sum(opp_serve_games),
    opp_total_service_bp_saved = sum(opp_break_points_saved),
    opp_total_service_bps = sum(opp_break_points),
    opp_service_games_played = opp_total_service_games,
    opp_service_games_lost = opp_total_service_bps - opp_total_service_bp_saved,
    opp_service_games_won = opp_service_games_played - opp_service_games_lost,
    avg_rank = mean(rank),
    avg_opp_rank = mean(opp_rank)
  ) %>%
  summarise(
    player = player, 
    ace_pct = total_aces/total_serve_points,
    df_pct = total_dfs/total_serve_points,
    first_serve_in_pct = first_serves_in/total_serve_points,
    first_serve_win_pct = first_serves_won/first_serves_in,
    second_serve_in_pct = second_serves_in/total_second_points,
    second_serve_win_pct = second_serves_won/second_serves_in,
    service_game_win_pct = service_games_won/service_games_played,
    service_bp_saved_pct = total_service_bp_saved/total_service_bps,
    first_return_win_pct = (opp_first_serves_in - opp_first_serves_won)/opp_first_serves_in,
    second_return_win_pct = (opp_second_serves_in - opp_second_serves_won)/opp_second_serves_in,
    return_game_win_pct = opp_service_games_lost/opp_service_games_played,
    return_bp_won_pct = (opp_total_service_bps - opp_total_service_bp_saved)/opp_total_service_bps,
    avg_rank = avg_rank,
    avg_opp_rank = avg_opp_rank
  ) %>%
  ungroup()
player_stats_yearly <- all_data %>%
  group_by(player, year) %>%
  summarise(
    total_aces = sum(aces),
    total_dfs = sum(dfs),
    total_serve_points = sum(first_serve_points),
    first_serves_in = sum(first_in),
    first_serves_won = sum(first_won),
    total_second_points = sum(second_serve_points),
    second_serves_in = sum(second_in),
    second_serves_won = sum(second_won),
    total_service_games = sum(serve_games),
    total_service_bp_saved = sum(break_points_saved),
    total_service_bps = sum(break_points),
    service_games_played = total_service_games,
    service_games_lost = total_service_bps - total_service_bp_saved,
    service_games_won = service_games_played - service_games_lost,
    opp_total_aces = sum(opp_aces),
    opp_total_dfs = sum(opp_dfs),
    opp_total_serve_points = sum(opp_first_serve_points),
    opp_first_serves_in = sum(opp_first_in),
    opp_first_serves_won = sum(opp_first_won),
    opp_total_second_points = sum(opp_second_serve_points),
    opp_second_serves_in = sum(opp_second_in),
    opp_second_serves_won = sum(opp_second_won),
    opp_total_service_games = sum(opp_serve_games),
    opp_total_service_bp_saved = sum(opp_break_points_saved),
    opp_total_service_bps = sum(opp_break_points),
    opp_service_games_played = opp_total_service_games,
    opp_service_games_lost = opp_total_service_bps - opp_total_service_bp_saved,
    opp_service_games_won = opp_service_games_played - opp_service_games_lost,
    avg_rank = mean(rank),
    avg_opp_rank = mean(opp_rank)
  ) %>%
  summarise(
    player = player,
    ace_pct = total_aces/total_serve_points,
    df_pct = total_dfs/total_serve_points,
    first_serve_in_pct = first_serves_in/total_serve_points,
    first_serve_win_pct = first_serves_won/first_serves_in,
    second_serve_in_pct = second_serves_in/total_second_points,
    second_serve_win_pct = second_serves_won/second_serves_in,
    service_game_win_pct = service_games_won/service_games_played,
    service_bp_saved_pct = total_service_bp_saved/total_service_bps,
    first_return_win_pct = (opp_first_serves_in - opp_first_serves_won)/opp_first_serves_in,
    second_return_win_pct = (opp_second_serves_in - opp_second_serves_won)/opp_second_serves_in,
    return_game_win_pct = opp_service_games_lost/opp_service_games_played,
    return_bp_won_pct = (opp_total_service_bps - opp_total_service_bp_saved)/opp_total_service_bps,
    avg_rank = avg_rank,
    avg_opp_rank = avg_opp_rank
  ) %>%
  ungroup()
# Create a csv for Novak's career match data in the 2010s
write.csv(novak, "Novak Match Data 2010-2019.csv")
write.csv(all_data, "All Match Data 2010-2019.csv")
write.csv(novak_stats, "Novak Total Match Stats 2010-2019.csv")
write.csv(player_stats, "All Player Stats 2010-2019.csv")
write.csv(player_stats_yearly, "All Player Stats by Year (2010-2019).csv")