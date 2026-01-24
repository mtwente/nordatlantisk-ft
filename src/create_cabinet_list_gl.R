# Setup -----
## Packages -----
library(here)

## External Functions -----
source(here("src", "utils", "annotate_csv.R"), local = TRUE)

## Create Data -----

cabinets_gl <- data.frame(
  cabinet = c(
    "enoksen_3", "enoksen_4", "enoksen_5", "kleist_1",
    "hammond_1", "hammond_2", "kielsen_0", "kielsen_1-1",
    "kielsen_1-2", "kielsen_2", "kielsen_3", "kielsen_4",
    "kielsen_5", "kielsen_6", "kielsen_7", "egede_1",
    "egede_2", "nielsen_1"
    ),
  wikidata_id = factor(c(
    "Q99672345", "Q99673310", "Q7604757", "Q7604603",
    "Q12333085", "Q99736342", "Q99736347", "Q18647396",
    "Q23022475", "Q48743208", "Q56863492", "Q95736906",
    "Q60747425", "Q96385892", "Q105834380", "Q106797236",
    "Q111486937", "Q133576206"
    )),
  location = factor(c(
    rep("GL", 18)
    )),
  start = as.Date(c(
    "2003-09-13", "2005-12-01", "2007-05-01", "2009-06-12",
    "2013-04-05", "2013-11-05", "2014-10-01", "2014-12-12",
    "2016-02-02", "2016-10-27", "2018-05-15", "2018-10-05",
    "2019-04-09", "2020-05-29", "2021-02-08", "2021-04-23",
    "2022-04-05", "2025-04-07"
    )),
  end = as.Date(c(
    "2005-12-01", "2007-05-01", "2009-06-12", "2013-04-05",
    "2013-11-05", "2014-10-01", "2014-12-12", "2016-02-02",
    "2016-10-27", "2018-05-15", "2018-10-05", "2019-04-09",
    "2020-05-29", "2021-02-08", "2021-04-23", "2022-04-05",
    "2025-04-07", NA
    )),
  GL_A  = c(FALSE, TRUE,  TRUE,  FALSE, TRUE,  TRUE,  FALSE, TRUE,  TRUE,  FALSE, TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, TRUE),
  GL_D  = c(FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, TRUE),
  GL_IA = c(TRUE,  TRUE,  FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,  TRUE,  TRUE),
  GL_KP = c(FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),
  GL_N  = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE),
  GL_NQ = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  FALSE, FALSE, FALSE),
  GL_PI = c(FALSE, FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),
  GL_SIU= c(TRUE,  TRUE,  TRUE,  FALSE, TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  FALSE, TRUE,  TRUE),
  stringsAsFactors = FALSE
  )

## Export -----

write.csv(
  cabinets_gl,
  here("data", "processed", "csv", "cabinets_gl.csv"),
  row.names = FALSE
)

saveRDS(
  cabinets_gl,
  here("data", "processed", "cabinets_gl.rds")
)

## Metadata -----

annotate_csv(cabinets_gl,
         dataset_description = "cabinets_gl is provided as csv and rds file in /data/processed/. It contains information on coalition governments of Greenland, in particular a timeline including the parties that are part of each cabinet during the timeframe covered by the northatlantic_ft dataset. Refer to the documentation for more details.",
         column_title = c(
           "Cabinet Name",
           "Wikidata ID",
           "Location",
           "Start Date",
           "End Date",
           "Atassut (A) Party Coalition Membership",
           "Demokraatit (D) Party Coalition Membership",
           "Inuit Ataqatigiit (IA) Party Coalition Membership",
           "Kattusseqatigiit Partiiat (KP) Party Coalition Membership",
           "Naleraq (N) Party Coalition Membership",
           "Nunatta Qitornai (NQ) Party Coalition Membership",
           "Partii Inuit (PI) Party Coalition Membership",
           "Siumut (SIU) Party Coalition Membership"
           ),
         column_description = c(
           "ID for the cabinet, usually named after the head of government",
           "Wikidata Identifier for the entity representing each cabinet",
           "Identifier whether this cabinet is from Greenland or the Faroe Islands",
           "Date the coalition took office",
           "Date the coalition left office",
           "Boolean indicating whether Atassut (A) was part of the cabinet",
           "Boolean indicating whether Demokraatit (D) were part of the cabinet",
           "Boolean indicating whether Inuit Ataqatigiit (IA) were part of the cabinet",
           "Boolean indicating whether Kattusseqatigiit Partiiat (KP) was part of the cabinet",
           "Boolean indicating whether Naleraq (N) was part of the cabinet",
           "Boolean indicating whether Nunatta Qitornai (NQ) was part of the cabinet",
           "Boolean indicating whether Partii Inuit (PI) was part of the cabinet",
           "Boolean indicating whether Siumut (SIU) was part of the cabinet"
           ))
