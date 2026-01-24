# Setup -----
## Packages -----
library(httr)
library(magrittr)
library(here)

## External Functions -----
source(here("src", "utils", "get_content.R"), local = TRUE)
source(here("src", "utils", "get_max_page_number.R"), local = TRUE)
source(here("src", "utils", "check_for_updates.R"))

# Definition -----

get_ballot_info <- function() {
  
  # ---- Read existing data ----
  local_path <- here("data", "raw", "ballot_info_raw.csv")
  
  existing_records <- if (file.exists(local_path)) {
    read.csv(local_path, stringsAsFactors = FALSE)
  } else {
    data.frame()
  }
  
  local_count <- nrow(existing_records)
  
  # ---- Compare local/online data ----
  update_check <- check_for_updates(
    count_url   = "https://oda.ft.dk/api/Afstemning?$inlinecount=allpages&$skip=0",
    ordered_url = "https://oda.ft.dk/api/Afstemning?$orderby=opdateringsdato%20desc&$top=1",
    local_count = local_count,
    data_path   = local_path
  )
  
  if (!update_check$needs_update) {
    
    message(
      "Ballot Data: No new records since last update (",
      format(update_check$mod_date, "%Y-%m-%d %H:%M:%S"),
      ")"
    )
    
    return(existing_records)
  }
  
  message(
    "Ballot Data: downloading ",
    update_check$total_count - local_count,
    " new or updated records"
  )
  
  # ---- Paging ----
  start_skip <- (local_count %/% 100) * 100
  max_skip   <- ((total_count - 1) %/% 100) * 100
  
  temp_downloaded_ballot_results <- data.frame()
  
  for (n in seq(start_skip, max_skip, 100)) {
    
    temp_content_ballot_results <- paste0(
      "https://oda.ft.dk/api/Afstemning?$inlinecount=allpages&$skip=",
      n
    ) %>%
      get_content()
    
    for (i in seq_along(temp_content_ballot_results[[3]])) {
      
      entry <- temp_content_ballot_results[[3]][[i]]
      
      if (!is.list(entry)) {
        warning("Skipping non-list element at index ", i, " on page ", n)
        next
      }
      
      temp_content_list <- lapply(entry, function(x) if (is.null(x)) NA else x)
      temp_content_df <- as.data.frame(t(unlist(temp_content_list)))
      
      temp_downloaded_ballot_results <- rbind(
        temp_downloaded_ballot_results,
        temp_content_df
      )
    }
  }
  
  # ---- Combine, deduplicate, sort ----
  combined_df <- bind_rows(existing_records, temp_downloaded_ballot_results) %>%
    distinct(id, .keep_all = TRUE) %>%
    arrange(id)
  
  write.csv(
    combined_df,
    file = local_path,
    row.names = FALSE
  )
  
  combined_df
}
