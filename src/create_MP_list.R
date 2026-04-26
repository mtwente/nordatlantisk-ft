# Setup -----
## Packages -----
library(here)

## External Functions -----
source(here("src", "utils", "annotate_csv.R"), local = TRUE)

## Create Data -----

named_columns <- c(
  "surname", "first_name", "MP_id",
  "wikidata_id", "origin", "party", "substitute"
)

rows <- list(
  ## Greenland -----
  c("Olsvig", "Sara", 13, "Q8084240", "GL", "IA", FALSE),
  c("Lund Olsen", "Johan", 277, "Q5965473", "GL", "IA", TRUE),
  c("Jakobsen", "Doris", 294, "Q12308847", "GL", "SIU", FALSE),
  c("Johansen", "Lars-Emil", 670, "Q468034", "GL", "SIU", FALSE),
  c("Kleist", "Kuupik", 672, "Q317400", "GL", "IA", FALSE),
  c("Rossen", "Sofia", 1484, "Q86523542", "GL", "IA", TRUE),
  c("Henningsen Heilmann", "Juliane", 6689, "Q533361", "GL", "IA", FALSE),
  c("Nielsen", "Nick", 14000, "Q16064655", "GL", "SIU", TRUE),
  c("Chemnitz", "Aaja", 15757, "Q20199803", "GL", "IA", FALSE),
  c("Hammond", "Aleqa", 15758, "Q1796195", "GL", "SIU, NQ", FALSE),
  c("Høegh-Dam", "Aki-Matilda", 18688, "Q64415132", "GL", "SIU, N", FALSE),
  c("Olsen", "Markus E.", 20635, "Q122762872", "GL", "SIU", TRUE),
  c("Kûitse", "Elvira", 21206, "Q136486981", "GL", "N", TRUE),
  c("Høegh-Dam", "Qarsoq", 21388, "Q132292501", "GL", "N", FALSE),
  c("Nathanielsen", "Naaja H.", 21387, "Q53872865", "GL", "IA", FALSE),
  
  ## Faroe Islands -----
  c("Joensen", "Edmund", 247, "Q678236", "FO", "B", FALSE),
  c("Petersen", "Lisbeth", 918, "Q544116", "FO", "B", FALSE),
  c("Arge", "Magni", 15881, "Q16167420","FO", "E", FALSE),
  c("Hoydal", "Høgni", 1833,  "Q567780", "FO", "E", FALSE),
  c("Johannesen", "Aksel", 12283, "Q556712", "FO", "C", TRUE),
  c("Skaale", "Sjúrður", 262, "Q845278", "FO", "C", FALSE),
  c("á Fríðriksmørk", "Annita", 6684, "Q466097", "FO", "E", TRUE),
  c("Kallsberg", "Anfinn", 3093, "Q529900", "FO", "A", FALSE),
  c("Falkenberg", "Anna", 20349, "Q114967087","FO","B", FALSE),
  c("Jacobsen", "Tórbjørn", 9780, "Q331736", "FO", "E", TRUE),
  c("Old", "Henrik", 18545, "Q3818072","FO", "C", TRUE),
  c("Johannesen", "Kaj Leo", 6687, "Q331786", "FO", "B", TRUE),
  c("Rasmussen", "Magnus", 19461, "Q17106707","FO","B", TRUE),
  c("Abrahamsen", "Helgi", 19996, "Q754881", "FO", "B", TRUE),
  c("Apol", "Barbara Gaardlykke",19142, "Q102501785","FO","C", TRUE),
  c("Dam", "Rigmor", 18614, "Q15633676","FO","C", TRUE),
  c("Hammer", "Bjarni", 17988, "Q20900614","FO","C", TRUE)
)

MP_names <- do.call(rbind, rows) |>
  as.data.frame(stringsAsFactors = FALSE,
                row.names = FALSE)

### Apply pre-defined names -----
colnames(MP_names) <- named_columns

## Coerce column types -----

MP_names$substitute   <- as.logical(MP_names$substitute)

MP_names$MP_id        <- factor(MP_names$MP_id)
MP_names$wikidata_id  <- factor(MP_names$wikidata_id)
MP_names$origin       <- factor(MP_names$origin)
MP_names$party        <- factor(MP_names$party)

# Export -----

write.csv(MP_names, here("data", "processed", "csv", "MP_names.csv"),
          row.names = FALSE)

saveRDS(MP_names, here("data", "processed", "MP_names.rds"))

## Metadata -----

annotate_csv(MP_names,
         dataset_description = "MP_names is provided in csv and rds formats in /data/processed. The csv file serves as starting point for building the data set, as the workflow pipeline retrieves data from Folketinget's Open Data Portal based on which MPs are listed in this file. This repository is shipped with a list of all Folketinget MPs that have represented the Faroe Islands and Greenland from October 07, 2004 until the most recent update of this data set. Refer to the documentation for more details.",
         primary_key = "MP_id",
         column_title = c(
           "Surname(s)",
           "First Name(s)",
           "MP ID",
           "Wikidata ID",
           "Origin",
           "Party Affiliation",
           "Substitute Membership"
           ),
         column_description = c(
           "Surname(s) of the MP. Names are spelled according to standardised orthography and, in terms of morphology, in nominative (Faroese) resp. absolutive (Greenlandic) case",
           "First Name(s) of the MP. Names are spelled according to standardised orthography and, in terms of morphology, in nominative (Faroese) resp. absolutive (Greenlandic) case",
           "Each MP is assigned an ID by Folketingets åbne data service (ODA). Each MP_id thus is a unique identifier for one member of Folketinget",
           "Wikidata Identifier for the entity representing each MP",
           "Geographical origin of the MP, using ISO 3166-2 codes",
           "Political Party the MP is member of, using the common abbreviation for Greenlandic Parties and the party letter code (Bogstavsbetegnelse) for Faroese parties. Note that some MPs belonged to several parties during their time in office. For more detailed membership information, see MP_dates.csv",
           "Boolean indicating whether the MP served Folketinget as a substitute member for another MP who went on leave"
           ))