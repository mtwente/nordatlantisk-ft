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
  
  # CSV Metadata -----
  
  annotate_csv(input_df,
           dataset_description = "nordatlantisk-ft is compiled from data available on Folketingets Open Data Platform and comprises voting records of MPs from Greenland and the Faroe Islands, documenting their voting behavior. It also contains metadata on each ballot – e.g. date and topic of each vote or the overall voting result. Refer to the documentation for more details.",
           primary_key = "vote_id",
           lang = list("en", "da"),
           column_title = c(
             "Ballot ID",
             "MP ID",
             "Surname(s)",
             "Origin",
             "Party",
             "Party Governing at Home",
             "Vote Type ID",
             "Vote ID",
             "Ballot Passing",
             "Process Step",
             "Topic ID",
             "Ballot Topic",
             "Vote Count: In Favor",
             "Vote Count: Against",
             "Vote Count: Abstaining",
             "Vote Count: Absentees",
             "Ballot Date",
             "Ballot Type ID",
             "Type of Government in Denmark",
             "Political Bloc of the Danish Government",
             "Comment",
             "Ballot Result String"),
           column_description = c(
             "ID assigned to the ballot in Folketinget records",
             "Folketinget ODA ID assigned to the MP",
             "Surname(s) of the MP",
             "Geographical origin of the MP, using ISO 3166-2 codes",
             "Political Party the MP is member of at the time of this vote, using the common abbreviation for Greenlandic Parties and the party letter code (Bogstavsbetegnelse) for Faroese parties",
             "Boolean indicating if the party the MP belongs to is part of the governing coalition in Greenland or Faroe Islands at the time of the vote",
             "Folketinget ODA ID assigned to the vote type",
             "Folketinget ODA ID assigned to the vote",
             "Boolean indicating if the ballot passed",
             "Stage of the parliamentary process the ballot is part of (in Danish)",
             "Folketinget ODA ID assigned to the parliamentary process the ballot is part of",
             "Description of the topic the proposal on the ballot is about (in Danish)",
             "Number of votes in favor of the proposal",
             "Number of votes against the proposal",
             "Number of abstention votes",
             "Number of absent MPs",
             "Date of the ballot",
             "Folketinget ODA ID assigned to the ballot type",
             "Indicates the type of cabinet governing in Denmark at the time of observation",
             "Indicates the political bloc of the cabinet governing in Denmark at the time of observation (red/left, blue/right or across)",
             "Additional comments about the ballot (in Danish)",
             "Description of the result (in Danish)"))
  
  return(input_df)
  
}