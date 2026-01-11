# Setup -----
## Packages -----
library(httr)
library(magrittr)
library(purrr)

## External Functions -----
source(here("src", "get_max_page_number.R"))
source(here("src", "get_content.R"))

# Definition -----

get_MP_record <- function(MP_id) {
  
  all_MP_votes <- data.frame()
  
  base_url <- paste0(
    "https://oda.ft.dk/api/Akt%C3%B8r(", MP_id,
    ")/Stemme?$inlinecount=allpages&$skip="
  )
  
  # ---- Get first page (skip = 0) ----
  first_page <- paste0(base_url, 0) %>%
    get_content()
  
  # odata.count is stored as character → coerce safely
  vote_count <- as.integer(first_page[["odata.count"]])
  
  # ---- Case: no voting records at all ----
  if (is.na(vote_count) || vote_count == 0) {
    message("No voting records found for MP ", MP_id)
    return(all_MP_votes)  # empty data frame for map_dfr()
  }
  
  # ---- Helper to append votes from a page ----
  append_votes <- function(content, df) {
    if (length(content[[3]]) == 0) return(df)
    
    temp_votes_list <- lapply(
      seq_along(content[[3]]),
      function(k) unlist(content[[3]][k][1])
    )
    
    for (vote in temp_votes_list) {
      df <- rbind(df, as.data.frame(t(vote)))
    }
    
    df
  }
  
  # ---- Process first page ----
  all_MP_votes <- append_votes(first_page, all_MP_votes)
  
  # ---- Determine max page number ----
  max_voting_page_number <- paste0(base_url, 0) %>%
    get_max_page_number()
  
  # ---- Process remaining pages (if any) ----
  if (max_voting_page_number > 0) {
    for (n in seq(100, max_voting_page_number, 100)) {
      temp_content_votes <- paste0(base_url, n) %>%
        get_content()
      
      all_MP_votes <- append_votes(temp_content_votes, all_MP_votes)
    }
  }
  
  return(all_MP_votes)
}
