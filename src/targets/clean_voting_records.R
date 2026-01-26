# Setup -----
## Packages -----
library(dplyr)
library(here)

# Definition -----

clean_voting_records <- function(input_df) {
  
  # Manipulate Data -----
  
  input_df <- subset(input_df, select = -opdateringsdato)
  
  colnames(input_df) <- c("vote_id", "vote_type_id", "ballot_id", "MP_id")
  
  output_df <- input_df %>%
    mutate(vote_id = as.factor(vote_id),
           vote_type_id = as.factor(vote_type_id),
           ballot_id = as.factor(ballot_id),
           MP_id = as.factor(MP_id)
    )
  
  # Export -----
  
  saveRDS(output_df, here("data", "processed", "northatlantic_votes.rds"))
  
  return(output_df)
}