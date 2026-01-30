# Setup -----
## Packages -----
library(here)
library(dplyr)

# Definition -----

clean_ballot_results <- function(input_df) {
  
  # ---- Basic cleaning ----
  input_df <- input_df %>%
    mutate(
      kommentar  = ifelse(kommentar == "", NA, kommentar),
      konklusion = ifelse(konklusion == "", NA, konklusion),
      dato       = gsub("[T].*$", "", dato)
    ) %>%
    select(-opdateringsdato)
  
  # ---- Rename columns to final schema ----
  colnames(input_df) <- c(
    "ballot_id", "ballot_nr", "ballot_result_string",
    "ballot_pass", "comment", "meeting_id",
    "ballot_type_id", "ft_process_id",
    "ballot_date",
    "ft_for", "ft_against", "ft_abstention", "ft_absent"
  )
  
  # ---- Reorder columns ----
  col_order <- c(
    "ballot_id", "meeting_id", "ballot_pass", "ballot_date",
    "ft_for", "ft_against", "ft_abstention", "ft_absent",
    "ft_process_id", "ballot_nr", "ballot_type_id",
    "comment", "ballot_result_string"
  )
  
  input_df <- input_df[, col_order]
  
  # ---- Type coercion ----
  input_df <- input_df %>%
    mutate(
      ballot_id        = as.integer(ballot_id),
      meeting_id       = as.integer(meeting_id),
      ballot_pass      = as.logical(ballot_pass),
      ballot_date      = as.Date(ballot_date, format = "%Y-%m-%d"),
      ft_for           = as.numeric(ft_for),
      ft_against       = as.numeric(ft_against),
      ft_abstention    = as.numeric(ft_abstention),
      ft_absent        = as.numeric(ft_absent),
      ft_process_id    = as.integer(ft_process_id),
      ballot_nr        = as.integer(ballot_nr),
      ballot_type_id   = as.integer(ballot_type_id),
      comment          = as.character(comment),
      ballot_result_string = as.character(ballot_result_string)
    )
  
  # ---- Save ----
  saveRDS(
    input_df,
    here("data", "processed", "ballot_results_ft.rds")
  )
  
  input_df
}
