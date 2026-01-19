# Setup -----
## Packages -----
library(dplyr)
library(here)

## External Functions -----
source(here("src", "match_party_affiliation.R"), local = TRUE)
source(here("src", "match_home_government.R"), local = TRUE)
source(here("src", "match_danish_government.R"), local = TRUE)

# Definition -----

join_results <- function(voting_records, ballot_results, ballot_topics, MP_names) {
  
  voting_records <- voting_records %>%
    left_join(ballot_results %>% select(ballot_id, ballot_pass, ballot_date,
                                           ft_for, ft_against, ft_abstention, ft_absent,
                                           ballot_type_id, comment, ballot_result_string, ft_process_id),
              by = "ballot_id") %>%
    
    left_join(MP_names %>% select(MP_id, surname, origin),
              by = "MP_id") %>%
    
    left_join(ballot_topics %>% select(ft_process_id, ft_process_step,
                                       ft_topic_id, ft_topic),
              by = "ft_process_id") %>%
    
    match_party_affiliation() %>%
    match_home_government() %>%
    match_danish_government()
  
  # Clean Up Data Frame Columns  -----
  
  col_order <- c("ballot_id", "MP_id", "surname", "origin", "party", "gvt_party_at_home",
                 "vote_type_id", "vote_id", "ballot_pass", "ft_process_step", "ft_topic_id",
                 "ft_topic", "ft_for", "ft_against", "ft_abstention", "ft_absent",
                 "ballot_date", "ballot_type_id", "gvt_type_dk", "gvt_bloc_dk",
                 "comment", "ballot_result_string")
  
  voting_records <- voting_records[, col_order]
  
  # Return -----
  
  return(voting_records)
  
}