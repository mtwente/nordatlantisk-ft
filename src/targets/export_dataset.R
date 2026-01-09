# Definition -----

export_dataset <- function(input_df) {
  
  # Export as CSV and RDS -----
  
  write.csv(input_df, file = here("data", "processed", "csv", "northatlantic_ft.csv"),
            row.names = FALSE)
  
  saveRDS(input_df, here("data", "processed", "northatlantic_ft.rds"))
  
  return(input_df)
  
}