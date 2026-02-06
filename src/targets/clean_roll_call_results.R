# Setup -----
## Packages -----
library(here)
library(dplyr)

# Definition -----

clean_roll_call_results <- function(input_df) {
  
  # ---- Basic cleaning ----
  input_df <- input_df %>%
    mutate(
      kommentar  = ifelse(kommentar == "", NA, kommentar),
      konklusion = ifelse(konklusion == "", NA, konklusion)
    ) %>%
    select(-opdateringsdato)
  
  # ---- Rename columns to final schema ----
  colnames(input_df) <- c(
    "roll_call_id", "roll_call_nr", "result_string",
    "roll_call_pass", "comment", "meeting_id",
    "roll_call_type_id", "ft_process_id", "ft_process_step",
    "ft_topic", "date",
    "ft_for", "ft_against", "ft_abstention", "ft_absent"
  )
  
  # ---- Reorder columns ----
  col_order <- c(
    "roll_call_id", "meeting_id", "roll_call_pass", "date",
    "ft_topic", "ft_for", "ft_against", "ft_abstention", "ft_absent",
    "ft_process_id", "ft_process_step", "roll_call_nr", "roll_call_type_id",
    "comment", "result_string"
  )
  
  input_df <- input_df[, col_order]
  
  # ---- Type coercion ----
  input_df <- input_df %>%
    mutate(
      roll_call_id        = as.integer(roll_call_id),
      meeting_id       = as.integer(meeting_id),
      roll_call_pass      = as.logical(roll_call_pass),
      date      = as.Date(date),
      ft_topic         = as.character(ft_topic),
      ft_for           = as.numeric(ft_for),
      ft_against       = as.numeric(ft_against),
      ft_abstention    = as.numeric(ft_abstention),
      ft_absent        = as.numeric(ft_absent),
      ft_process_id    = as.integer(ft_process_id),
      ft_process_step  = as.character(ft_process_step),
      roll_call_nr        = as.integer(roll_call_nr),
      roll_call_type_id   = as.integer(roll_call_type_id),
      comment          = as.character(comment),
      result_string = as.character(result_string)
    )
  
  # ---- Save ----
  saveRDS(
    input_df,
    here("data", "processed", "roll_call_results_ft.rds")
  )
  
  input_df
}
