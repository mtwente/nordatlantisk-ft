# Setup -----
## Packages -----
library(httr)
library(magrittr)
library(purrr)

## External Functions -----
source(here("src", "round.R"))
source(here("src", "get_max_page_number.R"))
source(here("src", "get_content.R"))

# Definition -----

get_MP_record <- function(MP_id) {
  
  all_MP_votes <- data.frame()
  
  max_voting_page_number <- paste0("https://oda.ft.dk/api/Akt%C3%B8r(", MP_id, ")/Stemme?$inlinecount=allpages&$skip=0") %>%
    get_max_page_number()
  
  for (n in seq(0, max_voting_page_number, 100)) {
    temp_content_votes <- paste0("https://oda.ft.dk/api/Akt%C3%B8r(", MP_id, ")/Stemme?$inlinecount=allpages&$skip=", n) %>%
      get_content()

    temp_votes_list <- 1:length(temp_content_votes[[3]]) %>%
      lapply(function(k) unlist(temp_content_votes[[3]][k][1]))
    
    for (vote in temp_votes_list) {
      all_MP_votes <- rbind(all_MP_votes, as.data.frame(t(vote)))
    }
  }
  
  return(all_MP_votes)
}