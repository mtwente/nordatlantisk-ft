# Setup -----
## Packages -----
library(here)
library(strex)
library(dplyr)

# Definition -----

clean_ballot_results <- function(input_df) {
  
  # Manipulate Data -----
  ## Add Missing Ballot Results from Strings -----
  
  input_df <- input_df %>%
    mutate(
      ft_for = ifelse(konklusion != "", str_nth_number(konklusion, n = 1), ft_for),
      ft_imod = ifelse(konklusion != "", str_nth_number(konklusion, n = 2), ft_imod),
      ft_hverken = ifelse(konklusion != "", str_nth_number(konklusion, n = 3), ft_hverken)
    )
  
  ## Calculate Number of Absent MPs for Each Ballot -----
  
  input_df$ft_fravaer <- 179 - rowSums(input_df[, c("ft_for", "ft_imod", "ft_hverken")])
  
  ## Clean and Format Data Frame -----
  
  input_df <- input_df[, -9] # removes opdateringsdato
  
  input_df <- input_df %>%
    mutate(kommentar = ifelse(kommentar == "", NA, kommentar),
           konklusion = ifelse(konklusion == "", NA, konklusion))
  
  input_df$dato <- gsub("[T].*$", '', input_df$dato)
  
  colnames(input_df) <- c("meeting_id", "ballot_id", "ballot_nr",
                                   "ballot_result_string", "ballot_pass", "comment",
                                   "ballot_type_id", "ft_process_id", "ballot_date",
                                   "ft_for", "ft_against", "ft_abstention", "ft_absent")
  
  col_order <- c("ballot_id", "meeting_id", "ballot_pass", "ballot_date",
                 "ft_for", "ft_against", "ft_abstention", "ft_absent",
                 "ft_process_id", "ballot_nr", "ballot_type_id",
                 "comment", "ballot_result_string")
  
  input_df <- input_df[, col_order]
  
  input_df <- input_df %>%
    mutate(ballot_id = as.factor(ballot_id),
           meeting_id = as.factor(meeting_id),
           ballot_pass = as.logical(ballot_pass),
           ballot_date = as.Date(ballot_date, format = "%Y-%m-%d"),
           ft_for = as.numeric(ft_for),
           ft_against = as.numeric(ft_against),
           ft_abstention = as.numeric(ft_abstention),
           ft_absent = as.numeric(ft_absent),
           ft_process_id = as.factor(ft_process_id),
           ballot_nr = as.factor(ballot_nr),
           ballot_type_id = as.factor(ballot_type_id),
           comment = as.character(comment),
           ballot_result_string = as.character(ballot_result_string)
    )
  
  # Export -----
  
  #write.csv(input_df, file = here("data", "processed", "csv", "ballot_results_ft.csv"),
  #          row.names = FALSE)
  
  saveRDS(input_df, here("data", "processed", "ballot_results_ft.rds"))
  
  return(input_df)
}