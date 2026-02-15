# Setup -----
## Packages -----
library(here)
library(dplyr)

# Definition -----

clean_roll_call_results <- function(roll_call_input, ministry_input) {
  
  # ---- Join ministry information ----
  output_df <- roll_call_input %>%
    left_join(
      ministry_input %>% select(sagid, ministerium),
      by = "sagid"
    )
  
  # ---- Basic cleaning ----
  output_df <- output_df %>%
    mutate(
      kommentar  = ifelse(kommentar == "", NA, kommentar),
      konklusion = ifelse(konklusion == "", NA, konklusion)
    ) %>%
    select(-opdateringsdato)
  
  # ---- Rename explicitly (safe) ----
  output_df <- output_df %>%
    rename(
      roll_call_id       = id,
      roll_call_nr       = nummer,
      result_string      = konklusion,
      roll_call_pass     = vedtaget,
      comment            = kommentar,
      meeting_id         = mødeid,
      roll_call_type_id  = typeid,
      ft_process_id      = sagstrinid,
      ft_process_step    = sagstrin_titel,
      ft_topic_id        = sagid,
      ft_topic           = sag_titel,
      date               = dato,
      ft_for             = ft_for,
      ft_against         = ft_against,
      ft_abstention      = ft_abstention,
      ft_absent          = ft_absent,
      ministry           = ministerium
    )
  
  # ---- Reorder columns ----
  col_order <- c(
    "roll_call_id", "meeting_id", "roll_call_pass", "date",
    "ft_topic", "ministry",
    "ft_for", "ft_against", "ft_abstention", "ft_absent",
    "ft_process_id", "ft_process_step", "roll_call_nr",
    "roll_call_type_id", "comment", "result_string"
  )
  
  output_df <- output_df %>%
    select(any_of(col_order))
  
  # ---- Type coercion ----
  output_df <- output_df %>%
    mutate(
      roll_call_id      = as.integer(roll_call_id),
      meeting_id        = as.integer(meeting_id),
      roll_call_pass    = as.logical(roll_call_pass),
      date              = as.Date(date),
      ft_topic          = as.character(ft_topic),
      ministry          = as.character(ministry),
      ft_for            = as.numeric(ft_for),
      ft_against        = as.numeric(ft_against),
      ft_abstention     = as.numeric(ft_abstention),
      ft_absent         = as.numeric(ft_absent),
      ft_process_id     = as.integer(ft_process_id),
      ft_process_step   = as.character(ft_process_step),
      roll_call_nr      = as.integer(roll_call_nr),
      roll_call_type_id = as.integer(roll_call_type_id),
      comment           = as.character(comment),
      result_string     = as.character(result_string)
    )
  
  # ---- Save ----
  saveRDS(
    output_df,
    here("data", "processed", "roll_call_results_ft.rds")
  )
  
  output_df
}
