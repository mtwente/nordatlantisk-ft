# Setup -----
library(here)
library(httr)
library(purrr)
library(dplyr)
library(magrittr)

source(here("src", "utils", "get_content.R"))
source(here("src", "utils", "format_api_datetime.R"))

# Definition -----

add_ministries <- function(input_df) {
  
  local_path <- here("data", "raw", "ministries_lookup.rds")
  
  existing_records <- if (file.exists(local_path)) {
    readRDS(local_path) %>%
      mutate(
        sagid           = as.integer(sagid),
        ministerium     = as.character(ministerium),
        opdateringsdato = as.POSIXct(opdateringsdato, tz = "UTC")
      )
  } else {
    tibble(
      sagid           = integer(),
      ministerium     = character(),
      opdateringsdato = as.POSIXct(character(), tz = "UTC")
    )
  }
  
  # Global last update
  last_update <- if (nrow(existing_records) > 0) {
    max(existing_records$opdateringsdato, na.rm = TRUE)
  } else {
    NULL
  }
  
  base_url <- paste0(
    "https://oda.ft.dk/api/SagAkt%C3%B8r?",
    "$filter=rolleid%20eq%206",
    "&$select=sagid,Akt%C3%B8r/navn,opdateringsdato",
    "&$expand=Akt%C3%B8r",
    "&$inlinecount=allpages"
  )
  
  api_url <- if (!is.null(last_update)) {
    paste0(
      base_url,
      "%20and%20opdateringsdato%20gt%20DateTime'",
      format_api_datetime(last_update),
      "'"
    )
  } else {
    base_url
  }
  
  message("Fetching ministry updates…")
  
  entries <- get_updated_records(api_url)
  
  if (length(entries) == 0) {
    message("No ministry updates found.")
    return(existing_records)
  }
  
  new_records <- purrr::map_dfr(entries, function(entry) {
    tibble(
      sagid = as.integer(entry$sagid),
      ministerium = entry$Aktør$navn %||% NA_character_,
      opdateringsdato = as.POSIXct(
        entry$opdateringsdato,
        format = "%Y-%m-%dT%H:%M:%OS",
        tz = "UTC"
      )
    )
  })
  
  output_df <- bind_rows(existing_records, new_records) %>%
    arrange(sagid, desc(opdateringsdato)) %>%
    distinct(sagid, ministerium, .keep_all = TRUE)
  
  saveRDS(output_df, local_path)
  
  # Filter only sagid relevant to current roll calls
  relevant_sagids <- input_df %>%
    distinct(sagid) %>%
    pull(sagid)
  
  output_df %>%
    filter(sagid %in% relevant_sagids)
}
