# Setup -----
## Packages -----
library(httr)
library(dplyr)
library(purrr)
library(tibble)
library(here)

## External Functions -----
source(here("src", "utils", "get_local_mtime.R"))
source(here("src", "utils", "format_api_datetime.R"))
source(here("src", "utils", "get_updated_records.R"))

# Definition -----
get_topics <- function(ballot_results) {
  
  # ---- Step 1: collect unique process IDs ----
  process_ids <- unique(ballot_results$ft_process_id)
  process_ids <- process_ids[!is.na(process_ids) & process_ids != ""]
  
  # ---- Step 2: load existing cache ----
  local_path <- here("data", "raw", "ballot_topics_raw.rds")
  
  topics_cache <- if (file.exists(local_path)) {
    readRDS(local_path) %>%
      mutate(
        ft_process_id   = as.integer(ft_process_id),
        ft_topic_id     = as.integer(ft_topic_id),
        opdateringsdato = as.POSIXct(opdateringsdato, tz = "UTC")
      )
  } else {
    tibble(
      ft_process_id   = integer(0),
      ft_process_step = character(0),
      ft_topic_id     = integer(0),
      ft_topic        = character(0),
      opdateringsdato = as.POSIXct(character(0), tz = "UTC")
    )
  }
  
  # ---- Step 3: determine incremental filter ----
  local_mtime_utc <- get_local_mtime(local_path)
  
  base_url <- "https://oda.ft.dk/api/Sagstrin?$expand=Sag"
  
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
  
  entries <- get_updated_records(api_url)
  
  if (length(entries) == 0) {
    message("No topic updates found.")
    return(topics_cache)
  }
  
  message("Fetching ", length(entries), " new or updated topics…")

  # ---- Step 4: parse entries ----
  new_topics <- map_dfr(entries, function(resp) {
    tibble(
      ft_process_id   = as.integer(resp$id),
      ft_process_step = resp$titel %||% NA_character_,
      ft_topic_id     = as.integer(resp$Sag$id %||% NA),
      ft_topic        = resp$Sag$titel %||% NA_character_,
      opdateringsdato = as.POSIXct(
        resp$opdateringsdato,
        format = "%Y-%m-%dT%H:%M:%OS",
        tz = "UTC"
      )
    )
  })
  
  # ---- Step 5: merge + keep newest per process ----
  topics_cache <- bind_rows(topics_cache, new_topics) %>%
    filter(ft_process_id %in% process_ids) %>%
    arrange(ft_process_id, desc(opdateringsdato)) %>%
    distinct(ft_process_id, .keep_all = TRUE)
  
  # ---- Step 6: save cache ----
  saveRDS(topics_cache, local_path)
  
  topics_cache
}
