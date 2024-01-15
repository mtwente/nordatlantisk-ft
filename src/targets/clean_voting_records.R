# Setup -----
## Packages -----
library(dplyr)
library(here)

# Definition -----

clean_voting_records <- function(raw_votes) {
  
  # Manipulate Data -----
  
  raw_votes <- raw_votes[, -5] # removes opdateringsdato
  
  colnames(raw_votes) <- c("vote_id", "vote_type_id", "ballot_id", "MP_id")
  
  raw_votes <- raw_votes %>%
    mutate(vote_id = as.factor(vote_id),
           vote_type_id = as.factor(vote_type_id),
           ballot_id = as.factor(ballot_id),
           MP_id = as.factor(MP_id)
    )
  
  # Export -----
  
  #write.csv(raw_votes, here("data", "processed", "csv", "northatlantic_votes.csv"),
  #          row.names = FALSE)
  
  saveRDS(raw_votes, here("data", "processed", "northatlantic_votes.rds"))
  
  return(raw_votes)
}