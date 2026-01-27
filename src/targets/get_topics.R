# Setup -----
## Packages -----
library(httr)
library(dplyr)
library(purrr)
library(tibble)
library(here)
library(readr)

## External helpers -----
source(here("src", "utils", "get_content.R"))

# Definition -----
get_topics <- function(ballot_results) {
  
  # ---- Step 1: collect unique process IDs (as integer) ----
  process_ids <- unique(ballot_results$ft_process_id)
  process_ids <- process_ids[!is.na(process_ids) & process_ids != ""]

  # ---- Step 2: load existing cache if available ----
  local_path <- here("data", "raw", "ballot_topics_raw.rds")
  
  if (file.exists(local_path)) {
    topics_cache <- readRDS(local_path)
  } else {
    topics_cache <- tibble(
      ft_process_id   = factor(),
      ft_process_step = character(),
      ft_topic_id = factor(),
      ft_topic        = character(),
    )
  }
  
  # ---- Step 3: identify missing process_ids ----
  missing_ids <- setdiff(process_ids, topics_cache$ft_process_id)
  
  if (length(missing_ids) > 0) {
    message("Fetching ", length(missing_ids), " new topics from API...")
    
    new_topics <- map_dfr(missing_ids, function(id) {
      url <- paste0("https://oda.ft.dk/api/Sagstrin(", id, ")?$expand=Sag")
      
      resp <- tryCatch({
        httr::GET(url) %>% httr::content(as = "parsed", encoding = "UTF-8")
      }, error = function(e) NULL)
      
      if (is.null(resp)) {
        tibble(
          ft_process_id   = as.integer(id),
          ft_topic        = NA_character_,
        )
      } else {
        tibble(
          ft_process_id   = as.integer(id),
          ft_topic_id     = as.factor(resp$id),
          ft_topic        = resp$titel %||% NA_character_
        )
      }
    })
    
    # ---- Step 4: merge with existing cache ----
    topics_cache <- bind_rows(topics_cache, new_topics) %>%
      distinct(ft_process_id, .keep_all = TRUE)
    
    # ---- Step 5: save updated cache ----
    saveRDS(topics_cache, file = local_path)
    
  }
  
  # ---- Return ----
  return(topics_cache)
}
