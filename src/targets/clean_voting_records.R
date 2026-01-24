# Setup -----
## Packages -----
library(dplyr)
library(here)

# Definition -----

clean_voting_records <- function(raw_votes) {
  
  # Manipulate Data -----
  
  raw_votes <- subset(raw_votes, select = -opdateringsdato)
  
  colnames(raw_votes) <- c("vote_id", "vote_type_id", "ballot_id", "MP_id")
  
  raw_votes <- raw_votes %>%
    mutate(vote_id = as.factor(vote_id),
           vote_type_id = as.factor(vote_type_id),
           ballot_id = as.factor(ballot_id),
           MP_id = as.factor(MP_id)
    )
  
  # Export -----
  
  saveRDS(raw_votes, here("data", "processed", "northatlantic_votes.rds"))
  
  return(raw_votes)
}