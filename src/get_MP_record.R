# Setup -----
## Packages -----
library(httr)
library(magrittr)
library(purrr)

## External Functions -----
source(here("src", "get_max_page_number.R"))
source(here("src", "get_content.R"))
source(here("src", "get_local_vote_count.R"))

# Definition -----

get_MP_record <- function(MP_id, existing_path, existing_records = NULL) {
  
  base_url <- paste0(
    "https://oda.ft.dk/api/Akt%C3%B8r(", MP_id,
    ")/Stemme?$inlinecount=allpages&$skip="
  )
  
  ordered_url <- paste0(
    "https://oda.ft.dk/api/Akt%C3%B8r(", MP_id,
    ")/Stemme?$orderby=opdateringsdato%20desc&$skip="
  )
  
  mod_date <- if (file.exists(existing_path)) {
    file.info(existing_path)$mtime
  } else {
    NA
  }
  
  # ---- First page: get odata.count ----
  first_page <- paste0(base_url, 0) %>%
    get_content()
  
  total_count <- as.integer(first_page[["odata.count"]])
  
  if (is.na(total_count) || total_count == 0) {
    message("No voting records found for MP ", MP_id)
    return(data.frame())
  }
  
  # ---- Local count ----
  existing_count <- get_local_vote_count(MP_id, existing_df)
  
  # ---- Timestamp check for newest updates ----
  ordered_first_page <- paste0(ordered_url, 0) %>%
    get_content()
  
  server_last_update <- if (length(ordered_first_page$value) > 0) {
    as.POSIXct(
      ordered_first_page$value[[1]]$opdateringsdato,
      format = "%Y-%m-%dT%H:%M:%OS",
      tz = "UTC"
    )
  } else {
    NA
  }
  
  # ---- Combined skip logic ----
  count_matches <- existing_count == total_count
  timestamp_up_to_date <-
    !is.na(mod_date) &&
    !is.na(server_last_update) &&
    server_last_update <= mod_date
  
  if (count_matches && timestamp_up_to_date) {
    
    message(
      "MP ", MP_id,
      ": No new records since the last update (",
      format(mod_date, "%Y-%m-%d %H:%M:%S"),
      ")"
    )
    
    return(data.frame())
  }
  
  # ---- Download required ----
  message(
    "MP ", MP_id,
    ": adding ",
    total_count - existing_count,
    " new or updated votes"
  )
  
  # ---- Append Records ----
  start_skip <- (existing_count %/% 100) * 100
  max_skip   <- ((total_count - 1) %/% 100) * 100
  
  all_MP_votes <- data.frame()
  
  append_votes <- function(content, df) {
    if (length(content$value) == 0) return(df)
    
    temp_votes <- map_dfr(
      content$value,
      ~ as.data.frame(.x, stringsAsFactors = FALSE)
    )
    
    bind_rows(df, temp_votes)
  }
  
  for (skip in seq(start_skip, max_skip, 100)) {
    page <- paste0(base_url, skip) %>%
      get_content()
    
    all_MP_votes <- append_votes(page, all_MP_votes)
  }
  
  # ---- Check for Duplicated Vote IDs ----
  if (!is.null(existing_df)) {
    all_MP_votes <- anti_join(
      all_MP_votes,
      existing_df,
      by = "id"
    )
  }
  
  all_MP_votes
}