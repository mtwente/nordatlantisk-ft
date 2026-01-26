# Setup -----
## Packages -----
library(purrr)
library(here)

## External Functions -----
source(here("src", "utils", "get_MP_record.R"), local = TRUE)

# Definition -----

get_voting_records <- function(input_df) {

  ## read pre-existing dataset to avoid duplicate downloads
  existing_path <- here("data", "raw", "northatlantic_votes_raw.csv")
  
  existing_records <- if (file.exists(existing_path)) {
    read.csv(existing_path, stringsAsFactors = FALSE)
  } else { NULL }
  
  
  ## download new voting records only
  new_records <- map_dfr(
    input_df$MP_id,
    get_MP_record,
    existing_path = existing_path,
    existing_records = existing_records
  )
  
  ## combine data and sort after MP and vote ID
  
  existing_records$opdateringsdato <- as.Date(existing_records$opdateringsdato)
  new_records$opdateringsdato <- as.Date(new_records$opdateringsdato)
  
  combined_votes <- bind_rows(existing_records, new_records) %>%
    distinct(id, .keep_all = TRUE) %>%
    arrange(aktørid, id)
  
  # Keep only MPs present in input_df
  combined_votes <- combined_votes %>%
    filter(aktørid %in% input_df$MP_id)
  
  ## export/return data
  write.csv(combined_votes, file = existing_path, row.names = FALSE)
  
  combined_votes
}