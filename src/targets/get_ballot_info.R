# Setup -----
## Packages -----
library(httr)
library(magrittr)
library(here)

## External Functions -----
source(here("src", "get_content.R"), local = TRUE)
source(here("src", "get_max_page_number.R"), local = TRUE)
source(here("src", "check_ballot_updates.R"), local = TRUE)

# Definition -----

get_ballot_info <- function() {
  
  data_path <- here("data", "raw", "ballot_info_raw.csv")
  
  # ---- Read existing data ----
  existing_df <- if (file.exists(data_path)) {
    read.csv(data_path, stringsAsFactors = FALSE)
  } else {
    data.frame()
  }
  
  existing_count <- nrow(existing_df)
  
  # ---- Online count ----
  first_page <- get_content(
    "https://oda.ft.dk/api/Afstemning?$inlinecount=allpages&$skip=0"
  )
  
  total_count <- as.integer(first_page[["odata.count"]])
  
  # ---- Timestamp check ----
  needs_update <- needs_update_ballot_info(data_path)
  
  if (!needs_update && existing_count == total_count) {
    
    mod_date <- file.info(data_path)$mtime
    
    message(
      "Ballot info: No new records since last update (",
      format(mod_date, "%Y-%m-%d %H:%M:%S"),
      ")"
    )
    
    return(existing_df)
  }
  
  message(
    "Ballot info: downloading ",
    total_count - existing_count,
    " new or updated records"
  )
  
  # ---- Paging ----
  start_skip <- (existing_count %/% 100) * 100
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
  combined_df <- bind_rows(existing_df, temp_downloaded_ballot_results) %>%
    distinct(id, .keep_all = TRUE) %>%
    arrange(id)
  
  write.csv(
    combined_df,
    file = data_path,
    row.names = FALSE
  )
  
  combined_df
}
