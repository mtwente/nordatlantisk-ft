# Setup -----
## Packages -----
library(here)

## External Functions -----
source(here("src", "utils", "annotate_csv.R"), local = TRUE)

# Definition -----

export_dataset <- function(northatlantic_ft) {
  
  # Clean Up Data Frame Columns  -----
  
  col_order <- c("roll_call_id", "MP_id", "surname", "origin", "party", "gvt_party_at_home",
                 "vote_type_id", "vote_id", "roll_call_pass", "ft_process_step",
                 "ft_topic", "ft_for", "ft_against", "ft_abstention", "ft_absent",
                 "roll_call_date", "roll_call_type_id", "gvt_type_dk", "gvt_bloc_dk",
                 "comment", "roll_call_result_string")
  
  northatlantic_ft <- northatlantic_ft[, col_order]
  
  # Export as CSV and RDS -----
  
  write.csv(northatlantic_ft, file = here("data", "processed", "csv", "northatlantic_ft.csv"),
            row.names = FALSE)
  
  saveRDS(northatlantic_ft, here("data", "processed", "northatlantic_ft.rds"))
  
  # CSV Metadata -----
  
  annotate_csv(northatlantic_ft,
           dataset_description = "nordatlantisk-ft is compiled from data available on Folketingets Open Data Platform and comprises voting records of MPs from Greenland and the Faroe Islands, documenting their voting behavior. It also contains metadata on each roll call – e.g. date and topic of each vote or the overall voting result. Refer to the documentation for more details.",
           primary_key = "vote_id",
           lang = list("en", "da"),
           column_title = c(
             "Roll Call ID",
             "MP ID",
             "Surname(s)",
             "Origin",
             "Party",
             "Party Governing at Home",
             "Vote Type ID",
             "Vote ID",
             "Roll Call Passing",
             "Process Step",
             "Roll Call Topic",
             "Vote Count: In Favor",
             "Vote Count: Against",
             "Vote Count: Abstaining",
             "Vote Count: Absentees",
             "Roll Call Date",
             "Roll Call Type ID",
             "Type of Government in Denmark",
             "Political Bloc of the Danish Government",
             "Comment",
             "Roll Call Result String"),
           column_description = c(
             "ID assigned to the roll call in Folketinget records",
             "Folketinget ODA ID assigned to the MP",
             "Surname(s) of the MP",
             "Geographical origin of the MP, using ISO 3166-2 codes",
             "Political Party the MP is member of at the time of this vote, using the common abbreviation for Greenlandic Parties and the party letter code (Bogstavsbetegnelse) for Faroese parties",
             "Boolean indicating if the party the MP belongs to is part of the governing coalition in Greenland or Faroe Islands at the time of the vote",
             "Folketinget ODA ID assigned to the vote type",
             "Folketinget ODA ID assigned to the vote",
             "Boolean indicating if the roll call passed",
             "Stage of the parliamentary process the roll call is part of (in Danish)",
             "Description of the topic the proposal on the roll call is about (in Danish)",
             "Number of votes in favor of the proposal",
             "Number of votes against the proposal",
             "Number of abstention votes",
             "Number of absent MPs",
             "Date of the roll call",
             "Folketinget ODA ID assigned to the roll call type",
             "Indicates the type of cabinet governing in Denmark at the time of observation",
             "Indicates the political bloc of the cabinet governing in Denmark at the time of observation (red/left, blue/right or across)",
             "Additional comments about the roll call (in Danish)",
             "Description of the result (in Danish)"))
  
  return(northatlantic_ft)
  
}