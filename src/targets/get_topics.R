# Setup -----
## Packages -----
library(here)
library(httr)
library(tibble)
library(dplyr)
library(readr)

# Definition -----
get_topics <- function(ballot_results) {
  
  # Step 1: collect unique ft_process_ids
  unique_ft_process_ids <- unique(ballot_results$ft_process_id)
  unique_ft_process_ids <- unique_ft_process_ids[!is.na(unique_ft_process_ids) & unique_ft_process_ids != ""]
  
  # Step 2: fetch Sagstrin data once per ft_process_id
  sagstrin_lookup <- purrr::map_dfr(unique_ft_process_ids, function(id) {
    sagstrin_url <- paste0("https://oda.ft.dk/api/Sagstrin(", id, ")")
    resp <- tryCatch({
      httr::GET(sagstrin_url) %>% httr::content(as = "parsed", encoding = "UTF-8")
    }, error = function(e) NULL)
    
    if (is.null(resp)) {
      tibble::tibble(ft_process_id = id, sagstrin = NA_character_, sagid = NA_integer_)
    } else {
      tibble::tibble(
        ft_process_id = id,
        sagstrin   = resp$titel %||% NA_character_,
        sagid      = resp$sagid %||% NA_integer_
      )
    }
  })
  
  # Step 3: fetch Sag data once per sagid
  unique_sagids <- unique(sagstrin_lookup$sagid)
  unique_sagids <- unique_sagids[!is.na(unique_sagids)]
  
  sag_lookup <- purrr::map_dfr(unique_sagids, function(id) {
    sag_url <- paste0("https://oda.ft.dk/api/Sag(", id, ")")
    resp <- tryCatch({
      httr::GET(sag_url) %>% httr::content(as = "parsed", encoding = "UTF-8")
    }, error = function(e) NULL)
    
    if (is.null(resp)) {
      tibble::tibble(sagid = id, sag_titel = NA_character_)
    } else {
      tibble::tibble(
        sagid      = id,
        sag_titel  = resp$titel %||% NA_character_
      )
    }
  })
  
  # Step 4: combine everything into one lookup
  ballot_topic <- sagstrin_lookup %>%
    dplyr::left_join(sag_lookup, by = "sagid")
  
  colnames(ballot_topic) <- c("ft_process_id", "ft_process_step", "ft_topic_id", "ft_topic")
  
  # Save
  readr::write_csv(ballot_topic, here::here("data", "raw", "ballot_topics_raw.csv"))
  
  return(ballot_topic)
}