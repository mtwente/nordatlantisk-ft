# Setup -----
## Packages -----
library(purrr)
library(dplyr)
library(here)

## External Functions -----
source(here("src", "utils", "get_vote_type_distribution.R"), local = TRUE)

# Definition -----

get_missing_info <- function(input_df) {
  
  vote_counts <- purrr::map_dfr(
    input_df$id,
    function(ballot_id) {
      
      dist <- get_vote_type_distribution(ballot_id)
      
      tibble(
        id = ballot_id,
        ft_for        = dist$n[dist$typeid == 1] %||% 0L,
        ft_against    = dist$n[dist$typeid == 2] %||% 0L,
        ft_abstention = dist$n[dist$typeid == 4] %||% 0L, #obs
        ft_absent     = dist$n[dist$typeid == 3] %||% 0L
      )
    }
  )
  
  input_df %>%
    left_join(vote_counts, by = "id")
}
