# Setup -----
## Packages -----
library(here)
library(httr)
library(magrittr)
library(purrr)

## External Functions -----
source(here("src", "utils", "get_local_mtime.R"))
source(here("src", "utils", "format_api_datetime.R"))
source(here("src", "utils", "get_updated_records.R"))

# Definition -----
get_ballot_info <- function() {
  
  # ---- Read existing data ----
  local_path <- here("data", "raw", "ballot_info_raw.rds")
  
  existing_records <- if (file.exists(local_path)) {
    readRDS(local_path) %>%
      mutate(
        id              = as.integer(id),
        nummer          = as.integer(nummer),
        konklusion      = as.character(konklusion),
        vedtaget        = as.logical(vedtaget),
        kommentar       = as.character(kommentar),
        mødeid          = as.integer(mødeid),
        typeid          = as.integer(typeid),
        sagstrinid      = as.integer(sagstrinid),
        sagstrin_titel  = as.character(sagstrin_titel),
        sag_titel       = as.character(sag_titel),
        dato            = as.POSIXct(dato, tz = "UTC"),
        opdateringsdato = as.POSIXct(
          opdateringsdato,
          format = "%Y-%m-%dT%H:%M:%OS",
          tz = "UTC"
        )
      )
  } else {
    data.frame(
      id              = integer(0),
      nummer          = integer(0),
      konklusion      = character(0),
      vedtaget        = logical(0),
      kommentar       = character(0),
      mødeid          = integer(0),
      typeid          = integer(0),
      sagstrinid      = integer(0),
      sagstrin_titel  = character(0),
      sag_titel       = character(0),
      dato            = as.POSIXct(character(0), tz = "UTC"),
      opdateringsdato = as.POSIXct(character(0), tz = "UTC"),
      stringsAsFactors = FALSE
    )
  }
  
  local_mtime_utc <- get_local_mtime(local_path)
  
  base_url <- paste0(
    "https://oda.ft.dk/api/Afstemning?",
    "$inlinecount=allpages",
    "&$select=id,nummer,konklusion,vedtaget,kommentar,m%C3%B8deid,typeid,",
    "sagstrinid,opdateringsdato,Sagstrin/titel,Sagstrin/Sag/titel,M%C3%B8de/dato",
    "&$expand=Sagstrin/Sag,M%C3%B8de"
  )
  
  api_url <- if (!is.null(local_mtime_utc)) {
    paste0(
      base_url,
      "&$filter=opdateringsdato%20gt%20DateTime'",
      format_api_datetime(local_mtime_utc),
      "'"
    )
  } else {
    base_url
  }
  
  message("Fetching new or updated ballot records from API…")
  
  entries <- get_updated_records(api_url)
  
  if (length(entries) == 0) {
    message("No updates found.")
    return(existing_records)
  }
  
  message("Fetching ", length(entries), " new or updated records…")
  
  parse_entry <- function(entry) {
    tibble::tibble(
      id              = entry$id,
      nummer          = entry$nummer %||% NA_character_,
      konklusion      = entry$konklusion %||% NA_character_,
      vedtaget        = entry$vedtaget %||% NA_character_,
      kommentar       = entry$kommentar %||% NA_character_,
      mødeid          = as.integer(entry$mødeid %||% NA),
      typeid          = as.integer(entry$typeid %||% NA),
      sagstrinid      = as.integer(entry$sagstrinid %||% NA),
      sagstrin_titel  = entry$Sagstrin$titel %||% NA_character_,
      sag_titel       = entry$Sagstrin$Sag$titel %||% NA_character_,
      dato            = as.POSIXct(entry$Møde$dato,
                                   format = "%Y-%m-%dT%H:%M:%OS",
                                   tz = "UTC")
                                   %||% NA_character_,
      opdateringsdato = as.POSIXct(entry$opdateringsdato,
                                   format = "%Y-%m-%dT%H:%M:%OS",
                                   tz = "UTC"
                                   )
    )
    }
  
  new_records <- purrr::map_dfr(entries, parse_entry)
  
  combined_df <- bind_rows(existing_records, new_records) %>%
    arrange(id, desc(opdateringsdato)) %>%
    distinct(id, .keep_all = TRUE)
  
  saveRDS(combined_df, local_path)
  
  combined_df
}
