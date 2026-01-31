# Setup -----
## Packages -----
library(dplyr)
library(here)

# Definition -----

join_results <- function(voting_records, ballot_results, MP_names) {
    
  voting_records <- voting_records %>%
    left_join(ballot_results %>% select(ballot_id, ballot_pass, ballot_date, ft_topic,
                                        ft_for, ft_against, ft_abstention, ft_absent,
                                        ballot_type_id, comment, ballot_result_string,
                                        ft_process_id, ft_process_step),
              by = "ballot_id") %>%
    
    left_join(MP_names %>% select(MP_id, surname, origin),
              by = "MP_id")
    
  # Return -----
  
  return(voting_records)
  
}