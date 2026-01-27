# Setup -----
## Packages -----
library(purrr)
library(here)

## External Functions -----
source(here("src", "utils", "get_MP_record.R"), local = TRUE)

# Definition -----

get_voting_records <- function(input_df) {

  ## read pre-existing dataset to avoid duplicate downloads
  local_path <- here("data", "raw", "northatlantic_votes_raw.rds")
  
  existing_records <- if (file.exists(local_path)) {
    readRDS(local_path)
  } else {
    existing_records <- data.frame(
      id = numeric(0),
      typeid = numeric(0),
      afstemningid = numeric(0),
      aktørid = numeric(0),
      opdateringsdato = as.Date(character(0)),
      stringsAsFactors = FALSE
    )
  }
  
  ## download new voting records only
  new_records <- map_dfr(
    input_df$MP_id,
    get_MP_record,
    existing_path = local_path,
    existing_records = existing_records
  )
  
  ## combine data and sort after MP and vote ID
  
  existing_records$opdateringsdato <- as.Date(existing_records$opdateringsdato)
  new_records$opdateringsdato <- as.Date(new_records$opdateringsdato)
  
  updated_votes <- bind_rows(existing_records, new_records) %>%
    distinct(id, .keep_all = TRUE) %>%
    arrange(aktørid, id)
  
  # Keep only MPs present in input_df
  updated_votes <- updated_votes %>%
    filter(aktørid %in% input_df$MP_id)
  
  ## export/return data
  saveRDS(updated_votes, file = local_path)
  
  updated_votes
}