# Setup -----
## Packages -----
library(here)

## External Functions -----
source(here("src", "annotate_csv.R"), local = TRUE)

## Create Data -----

cabinets_dk <- data.frame(
  cabinet = c(
    "rasmussen-a-f_1",
    "rasmussen-a-f_2",
    "rasmussen-a-f_3",
    "rasmussen-l-l_1",
    "thorning-schmidt_1",
    "thorning-schmidt_2",
    "rasmussen-l-l_2",
    "rasmussen-l-l_3",
    "frederiksen_1",
    "frederiksen_2"
  ),
  wikidata_id = factor(c(
    "Q1549269",
    "Q2137611",
    "Q1890260",
    "Q1485892",
    "Q283704",
    "Q15707210",
    "Q20451905",
    "Q27924454",
    "Q64831553",
    "Q115694681"
  )),
  bloc = factor(c(
    "right",
    "right",
    "right",
    "right",
    "left",
    "left",
    "right",
    "right",
    "left",
    "across"
  )),
  type = factor(c(
    "coalition",
    "coalition",
    "coalition",
    "coalition",
    "coalition",
    "coalition",
    "single_party",
    "coalition",
    "single_party",
    "coalition"
  )),
  start = as.Date(c(
    "2001-11-27",
    "2005-02-18",
    "2007-11-23",
    "2009-04-05",
    "2011-10-03",
    "2014-02-03",
    "2015-06-28",
    "2016-11-28",
    "2019-06-27",
    "2022-12-15"
  )),
  end = as.Date(c(
    "2005-02-18",
    "2007-11-23",
    "2009-04-05",
    "2011-10-03",
    "2014-02-03",
    "2015-06-28",
    "2016-11-28",
    "2019-06-27",
    "2022-12-15",
    NA
  )),
  DK_A = c(FALSE, FALSE, FALSE, FALSE, TRUE,  TRUE,  FALSE, FALSE, TRUE,  TRUE),
  DK_B = c(FALSE, FALSE, FALSE, FALSE, TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE),
  DK_C = c(TRUE,  TRUE,  TRUE,  TRUE,  FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE),
  DK_F = c(FALSE, FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE),
  DK_I = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE),
  DK_M = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE),
  DK_V = c(TRUE,  TRUE,  TRUE,  TRUE,  FALSE, FALSE, TRUE,  TRUE,  FALSE, TRUE),
  stringsAsFactors = FALSE
)

## Export -----

write.csv(
  cabinets_dk,
  here("data", "processed", "csv", "cabinets_dk.csv"),
  row.names = FALSE
)

saveRDS(
  cabinets_dk,
  here("data", "processed", "cabinets_dk.rds")
)

## Metadata -----

annotate(cabinets_dk,
         dataset_description = "cabinets_dk is provided as csv and rds file in /data/processed/. It contains information on coalition governments of Denmark, in particular a timeline including the parties that are part of each cabinet during the timeframe covered by the northatlantic_ft dataset. Refer to the documentation for more details.",
         primary_key = "cabinet",
         lang = list("en"),
         column_title = c(
           "Cabinet Name",
           "Wikidata ID",
           "Party Bloc",
           "Cabinet Type",
           "Start Date",
           "End Date",
           "Socialdemokratiet (A) Party Coalition Membership",
           "Radikale Venstre (B) Party Coalition Membership",
           "Det Konservative Folkeparti (C) Party Coalition Membership",
           "Socialistisk Folkeparti (F) Party Coalition Membership",
           "Liberal Alliance (I) Party Coalition Membership",
           "Moderaterne (M) Party Coalition Membership",
           "Venstre (V) Party Coalition Membership"
           ),
         column_description = c(
           "ID for the cabinet, usually named after the head of government",
           "Wikidata Identifier for the entity representing each cabinet",
           "String identifying whether the government coalition belongs to the left (red) or right (blue) bloc of Danish politics, or is formed across blocs (across)",
           "String identifying whether the government is a single-party government (single_party) or a coalition government (coalition)",
           "Date the coalition took office",
           "Date the coalition left office",
           "Boolean indicating whether Socialdemokratiet (A) was part of the cabinet",
           "Boolean indicating whether Radikale Venstre (B) was part of the cabinet",
           "Boolean indicating whether Det Konservative Folkeparti (C) was part of the cabinet",
           "Boolean indicating whether Socialistisk Folkeparti (F) was part of the cabinet",
           "Boolean indicating whether Liberal Alliance (I) was part of the cabinet",
           "Boolean indicating whether Moderaterne (M) were part of the cabinet",
           "Boolean indicating whether Venstre (V) was part of the cabinet"
           ))
