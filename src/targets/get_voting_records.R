# Setup -----
## Packages -----
library(purrr)
library(here)

## External Functions -----
source(here("src", "get_MP_record.R"), local = TRUE)

# Definition -----

get_voting_records <- function(input_df) {
  MP_names <- as.data.frame(input_df)
  
  northatlantic_votes <- map_dfr(MP_names$MP_id, get_MP_record)
  
  write.csv(northatlantic_votes, file = here("data", "raw", "northatlantic_votes_raw.csv"),
            row.names = FALSE)
  
  return(northatlantic_votes)
}