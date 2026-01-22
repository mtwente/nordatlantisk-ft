# Definition -----

export_dataset <- function(input_df) {
  
  # Clean Up Data Frame Columns  -----
  
  col_order <- c("ballot_id", "MP_id", "surname", "origin", "party", "gvt_party_at_home",
                 "vote_type_id", "vote_id", "ballot_pass", "ft_process_step", "ft_topic_id",
                 "ft_topic", "ft_for", "ft_against", "ft_abstention", "ft_absent",
                 "ballot_date", "ballot_type_id", "gvt_type_dk", "gvt_bloc_dk",
                 "comment", "ballot_result_string")
  
  input_df <- input_df[, col_order]
  
  # Export as CSV and RDS -----
  
  write.csv(input_df, file = here("data", "processed", "csv", "northatlantic_ft.csv"),
            row.names = FALSE)
  
  saveRDS(input_df, here("data", "processed", "northatlantic_ft.rds"))
  
  return(input_df)
  
}