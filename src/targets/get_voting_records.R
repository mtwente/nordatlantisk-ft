# Setup -----
## Packages -----
library(purrr)
library(here)
library(magrittr)
library(dplyr)

## External Functions -----
source(here("src", "utils", "get_MP_record.R"), local = TRUE)

# Definition -----

get_voting_records <- function(input_df) {
  
  local_path <- here("data", "raw", "northatlantic_votes_raw.rds")
  
  existing_records <- if (file.exists(local_path)) {
    readRDS(local_path) %>%
      mutate(
        id              = as.integer(id),
        typeid          = as.integer(typeid),
        afstemningid    = as.integer(afstemningid),
        aktørid         = as.integer(aktørid),
        opdateringsdato = as.POSIXct(
          opdateringsdato,
          format = "%Y-%m-%dT%H:%M:%OS",
          tz = "UTC"
        )
      )
  } else {
    data.frame(
      id              = integer(0),
      typeid          = integer(0),
      afstemningid    = integer(0),
      aktørid         = integer(0),
      opdateringsdato = as.POSIXct(character(0), tz = "UTC"),
      stringsAsFactors = FALSE
    )
  }
  
  local_mtime_utc <- get_local_mtime(local_path)

  new_records <- purrr::map_dfr(
    input_df$MP_id,
    get_MP_record,
    local_mtime_utc = local_mtime_utc
  )
  
  if (nrow(new_records) == 0) {
    message(
      "MP ", MP_id,
      ": No new records since last update (",
      format(local_mtime_utc, "%Y-%m-%d %H:%M:%S"),
      ")"
    )
    
    return(existing_records)
  }
  
  combined_df <- bind_rows(existing_records, new_records) %>%
    arrange(id, desc(opdateringsdato)) %>%
    distinct(id, .keep_all = TRUE) %>%
    filter(aktørid %in% input_df$MP_id)
  
  saveRDS(combined_df, local_path)
  
  combined_df
}
