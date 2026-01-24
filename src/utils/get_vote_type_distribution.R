# Setup -----
## Packages -----
library(httr)
library(purrr)
library(dplyr)

## External Functions -----
source(here("src", "utils", "get_content.R"), local = TRUE)

# Definition -----

get_vote_type_distribution <- function(afstemning_id) {
  base_url <- paste0(
    "https://oda.ft.dk/api/Afstemning(",
    afstemning_id,
    ")/Stemme?$inlinecount=allpages&$skip="
  )
  
  first_page <- get_content(paste0(base_url, 0))
  total <- as.integer(first_page[["odata.count"]])
  
  if (is.na(total) || total == 0) {
    return(tibble(typeid = integer(), n = integer()))
  }
  
  max_skip <- ((total - 1) %/% 100) * 100
  votes <- purrr::map_dfr(
    seq(0, max_skip, 100),
    ~ get_content(paste0(base_url, .x))$value
  )
  
  votes %>%
    count(typeid, name = "n")
}
