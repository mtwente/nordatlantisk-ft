# Setup -----
## Packages -----
library(dplyr)
library(here)

# Definition -----

join_results <- function(voting_records, ballot_results) {
  
  voting_records <- voting_records %>%
    left_join(ballot_results %>% select(ballot_id, ballot_pass, ballot_date,
                                           ft_for, ft_against, ft_abstention, ft_absent,
                                           ballot_type_id, comment, ballot_result_string),
              by = "ballot_id")
  
  # Clean Up Data Frame Columns  -----
  
  col_order <- c("ballot_id", "MP_id", "vote_type_id", "vote_id",
                 "ballot_pass", "ft_for", "ft_against", "ft_abstention", "ft_absent",
                 "ballot_date", "ballot_type_id", "comment", "ballot_result_string")
  
  voting_records <- voting_records[, col_order]
  
  # Export -----
  
  write.csv(voting_records, file = here("data", "processed", "csv", "northatlantic_ft.csv"),
            row.names = FALSE)
  
  saveRDS(voting_records, here("data", "processed", "northatlantic_ft.rds"))
  
  return(voting_records)
  
}