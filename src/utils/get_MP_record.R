# Setup -----
## Packages -----
library(httr)
library(magrittr)
library(purrr)

## External Functions -----
source(here("src", "utils", "get_max_page_number.R"))
source(here("src", "utils", "get_content.R"))
source(here("src", "utils", "get_local_vote_count.R"))
source(here("src", "utils", "check_for_updates.R"))

# Definition -----

get_MP_record <- function(MP_id, existing_path, existing_records = NULL) {
  
  base_url <- paste0(
    "https://oda.ft.dk/api/Akt%C3%B8r(", MP_id,
    ")/Stemme?$inlinecount=allpages&$skip="
  )
  
  local_count <- get_local_vote_count(MP_id, existing_records)
  
  # ---- Compare local/online data ----
  update_check <- check_for_updates(
    count_url = paste0(base_url, "0"),
    ordered_url = paste0(
      "https://oda.ft.dk/api/Akt%C3%B8r(", MP_id,
      ")/Stemme?$orderby=opdateringsdato%20desc&$top=1"
    ),
    local_count = local_count,
    data_path   = existing_path
  )
  
  if (!update_check$needs_update) {
    
    message(
      "MP ", MP_id,
      ": No new records since last update (",
      format(update_check$mod_date, "%Y-%m-%d %H:%M:%S"),
      ")"
    )
    
    return(data.frame())
  }
  
  if (update_check$total_count == 0 ) {
    message(
      "MP ", MP_id,
      ": No records found for this ID"
    )
  } else if (update_check$total_count > local_count) {
    message(
      "MP ", MP_id,
      ": adding ",
      update_check$total_count - local_count,
      " new votes"
    )
  } else {
    message(
      "MP ", MP_id,
      ": re-downloading votes due to corrections"
    )
  }
  
  # ---- Append Records ----
  # ---- Decide paging strategy ----
  if (update_check$total_count <= 0) {
    return(data.frame())
  }
  
  if (local_count < update_check$total_count) {
    # Incremental append
    start_skip <- (local_count %/% 100) * 100
  } else {
    # Corrections, deletions, or mismatches → full refresh
    start_skip <- 0
  }
  
  max_skip <- ((update_check$total_count - 1) %/% 100) * 100
  
  # ---- Hard safety guard ----
  if (start_skip > max_skip) {
    start_skip <- 0
  }
  
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
  if (!is.null(existing_records)) {
    all_MP_votes <- anti_join(
      all_MP_votes,
      existing_records,
      by = "id"
    )
  }
  
  all_MP_votes
}