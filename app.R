library(shiny)
library(dplyr)
# Set seed to create randomized bracket
set.seed(99999)
# Create a list of randomized players
players <- strsplit(c("Alexia, David J, David F, Evan, Everett, Jackson, Jarrett, Jordan, Luigi, Luke, Manas, Mark, Nick, Nihar, Rick, Sami, Sebastian, Timmy, Vandy, Zach B, Zach C, Zak, Zander"), ", ")[[1]]
randomized <- sample(players)
cat(paste(randomized), sep = "\n")
# Create rounds for the winners bracket
round_1_matchups <- data.frame(
  round = rep("1a", times = 7), 
  player_1 = c(randomized[16], randomized[13], randomized[12], randomized[15], randomized[10], randomized[14], randomized[11]),
  player_2 = c(randomized[17], randomized[20], randomized[21], randomized[18], randomized[23], randomized[19], randomized[22])
)
round_2_matchups <- data.frame(
  round = rep("2a", times = 8),
  player_1 = c(randomized[1], randomized[8], randomized[4], randomized[5], randomized[2], randomized[7], randomized[3], randomized[6]),
  player_2 = c("Winner Match 1", randomized[9], "Winner Match 2", "Winner Match 3", "Winner Match 4", "Winner Match 5", "Winner Match 6", "Winner Match 7")
)
round_3_matchups <- data.frame(
  round = rep("3a", times = 4),
  player_1 = c("Winner Match 9", "Winner Match 10", "Winner Match 12", "Winner Match 14"),
  player_2 = c("Winner Match 8", "Winner Match 11", "Winner Match 13", "Winner Match 15")
)
round_4_matchups <- data.frame(
  round = rep("4a", times = 2),
  player_1 = c("Winner Match 27", "Winner Match 29"),
  player_2 = c("Winner Match 28", "Winner Match 30")
)
winners_championship <- data.frame(
  round = "5a",
  player_1 = "Winner Match 37",
  player_2 = "Winner Match 38"
)
championship <- data.frame(
  round = "6a",
  player_1 = "Winner Match 42",
  player_2 = "Winner Match 41"
)
# Create loser's bracket
round_1_losers <- data.frame(
  round = rep("1b", times = 7),
  player_1 = c("Loser Match 1", "Loser Match 2", "Loser Match 3", "Loser Match 4", "Loser Match 5", "Loser Match 6", "Loser Match 7"),
  player_2 = c("Loser Match 15", "Loser Match 13", "Loser Match 12", "Loser Match 11", "Loser Match 10", "Loser Match 8", "Loser Match 9")
)
round_2_losers <- data.frame(
  round = rep("2b", times = 4),
  player_1 = c("Loser Match 14", "Winner Match 21", "Winner Match 19", "Winner Match 16"),
  player_2 = c("Winner Match 22", "Winner Match 20", "Winner Match 18", "Winner Match 17")
)
round_3_losers <- data.frame(
  round = rep("3b", times = 4),
  player_1 = c("Loser Match 28", "Loser Match 27", "Loser Match 30", "Loser Match 29"),
  player_2 = c("Winner Match 26", "Winner Match 25", "Winner Match 24", "Winner Match 23")
)
round_4_losers <- data.frame(
  round = rep("4b", times = 2),
  player_1 = c("Winner Match 32", "Winner Match 34"),
  player_2 = c("Winner Match 31", "Winner Match 33")
)
round_5_losers <- data.frame(
  round = rep("5b", times = 2),
  player_1 = c("Loser Match 38", "Loser Match 37"),
  player_2 = c("Winner Match 35", "Winner Match 36")
)
championship_losers <- data.frame(
  round = "6b",
  player_1 = "Winner Match 40",
  player_2 = "Winner Match 39"
)
# Combine all bracket events
bracket <- bind_rows(round_1_matchups, round_2_matchups, round_1_losers, round_2_losers, round_3_matchups, round_3_losers, round_4_losers, round_4_matchups, round_5_losers, championship_losers, winners_championship, championship)
# Order matchups chronologically
bracket$match_num <- 1:nrow(bracket)
bracket$bracket_id <- paste(bracket$round, bracket$match_num, sep = "_")
bracket$winner <- "NA"
bracket$loser <- "NA"
bracket <- bracket[c(5, 1, 4, 2, 3, 6, 7)]
# Function to calculate the winner for each match based on user input
update_bracket <- function(bracket, match_num, winner, loser) {
  updated_bracket <- bracket
  # Subset updated_bracket winner/loser 
  updated_bracket$winner[updated_bracket$match_num == match_num] <- winner
  updated_bracket$loser[updated_bracket$match_num == match_num] <- loser
  return(updated_bracket)
}
# Function to update subsequent matches based on the winner and loser
update_subsequent_matches <- function(bracket, match_num, winner, loser) {
  updated_bracket <- bracket
  # Update player_1 and player_2 in subsequent matches referencing match_num
  # Do this separately for winners and losers
  updated_bracket$player_1[grepl(paste0("Winner Match ", match_num, "$"), updated_bracket$player_1)] <- winner
  updated_bracket$player_2[grepl(paste0("Winner Match ", match_num, "$"), updated_bracket$player_2)] <- winner
  updated_bracket$player_1[grepl(paste0("Loser Match ", match_num, "$"), updated_bracket$player_1)] <- loser
  updated_bracket$player_2[grepl(paste0("Loser Match ", match_num, "$"), updated_bracket$player_2)] <- loser
  
  return(updated_bracket)
}
# Set the user interface
ui <- fluidPage(
  titlePanel("2023 Drumlins Invitational"),
  sidebarLayout(
    sidebarPanel(
      # Create 3 inputs for the user with a submit button
      # Limit the choices to only that specific match and the specific players for the match
      selectInput("match_num", "Select Match:", choices = unique(bracket$match_num)),
      selectInput("winner", "Winner:", choices = unique(c(bracket$player_1, bracket$player_2))),
      selectInput("loser", "Loser:", choices = unique(c(bracket$player_1, bracket$player_2))),
      actionButton("submit", "Submit")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Bracket", tableOutput("bracket_table"))
      )
    )
  )
)
# Set the server for the bracket
server <- function(input, output, session) {
  bracket_data <- reactiveVal(bracket)
  observe({
    match_num <- input$match_num
    # Sets the players unique to only those possible for the match
    match_players <- unique(c(bracket_data()$player_1[bracket_data()$match_num == match_num], bracket_data()$player_2[bracket_data()$match_num == match_num]))
    # Set "default" players to player 1 and 2 for display purposes
    default_winner <- match_players[1] 
    default_loser <- match_players[2] 
    # Update inputs within the shiny app for winners and losers
    updateSelectInput(session, "winner", "Winner:", choices = match_players, selected = default_winner)
    updateSelectInput(session, "loser", "Loser:", choices = match_players, selected = default_loser)
  })
  # Use observeEvent to update the bracket along user inputs
  observeEvent(input$submit, {
    # Updates the bracket winner and loser column based on inputs
    match_num <- input$match_num
    winner <- input$winner
    loser <- input$loser
    updated_bracket <- update_bracket(bracket_data(), match_num, winner, loser)
    bracket_data(updated_bracket)
    # Updates the player_1 and player_2 columns based on inputs
    updated_bracket <- update_subsequent_matches(updated_bracket, match_num, winner, loser)
    bracket_data(updated_bracket)
  })
  # Render the bracket in the UI
  output$bracket_table <- renderTable({
    bracket_data()
  })
}
# Display the app
shinyApp(ui, server)