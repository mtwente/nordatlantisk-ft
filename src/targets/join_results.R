# Setup -----
## Packages -----
library(dplyr)
library(here)

# Definition -----

join_results <- function(voting_records, roll_call_results, MP_names) {
    
  voting_records <- voting_records %>%
    left_join(roll_call_results %>% select(roll_call_id, roll_call_pass, date, ft_topic, ministry,
                                        ft_for, ft_against, ft_abstention, ft_absent,
                                        roll_call_type_id, comment, result_string,
                                        ft_process_id, ft_process_step),
              by = "roll_call_id") %>%
    
    left_join(MP_names %>% select(MP_id, surname, origin),
              by = "MP_id")
    
  # Return -----
  
  return(voting_records)
  
}