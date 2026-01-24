# Setup -----
## Packages -----
library(here)

## External Functions -----
source(here("src", "utils", "annotate_csv.R"), local = TRUE)

## Template -----

#MP_names <- data.frame(surname = c("Name1", "Name2", "Name3", "Name4", "Name5", ...),
#                       MP_id = factor(c(1,2,3,4,5, ...)),
#                       ...)

## Create Data -----

MP_names_GL <- data.frame(surname = c("Olsvig", "Lund Olsen", "Jakobsen", "Johansen", "Kleist", "Rossen", "Henningsen Heilmann", "Nielsen", "Chemnitz", "Hammond", "Høegh-Dam", "Olsen", "Kûitse"),
                         first_name = c("Sara", "Johan", "Doris", "Lars-Emil", "Kuupik", "Sofia", "Juliane", "Nick", "Aaja", "Aleqa", "Aki-Matilda", "Markus E.", "Elvira"),
                         MP_id = factor(c(13, 277, 294, 670, 672, 1484, 6689, 14000, 15757, 15758, 18688, 20635, 21206)),
                         wikidata_id = factor(c("Q8084240", "Q5965473", "Q12308847", "Q468034", "Q317400", "Q86523542", "Q533361", "Q16064655", "Q20199803", "Q1796195", "Q64415132", "Q122762872", "Q136486981")),
                         origin = factor(rep("GL", 13)),
                         party = factor(c("IA", "IA", "SIU", "SIU", "IA", "IA", "IA", "SIU", "IA", "SIU, NQ", "SIU, N", "SIU", "N")),
                         substitute = c(FALSE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, TRUE, TRUE)
                         )

MP_names_FO <-  data.frame(surname = c("Joensen", "Petersen", "Arge", "Hoydal", "Johannesen", "Skaale", "á Fríðriksmørk", "Kallsberg", "Falkenberg", "Jacobsen", "Old", "Johannesen", "Rasmussen", "Abrahamsen", "Apol", "Dam", "Hammer"),
                          first_name = c("Edmund", "Lisbeth", "Magni", "Høgni", "Aksel", "Sjúrður", "Annita", "Anfinn", "Anna", "Tórbjørn", "Henrik", "Kaj Leo", "Magnus", "Helgi", "Barbara Gaardlykke", "Rigmor", "Bjarni"),
                          MP_id = factor(c(247, 918, 15881, 1833, 12283, 262, 6684, 3093, 20349, 9780, 18545, 6687, 19461, 19996, 19142, 18614, 17988)),
                          wikidata_id = factor(c("Q678236", "Q544116", "Q16167420", "Q567780", "Q556712", "Q845278", "Q466097", "Q529900", "Q114967087", "Q331736", "Q3818072", "Q331786", "Q17106707", "Q754881", "Q102501785", "Q15633676", "Q20900614")),
                          origin = factor(rep("FO", 17)),
                          party = factor(c("B", "B", "E", "E", "C", "C", "E", "A", "B", "E", "C", "B", "B", "B", "C", "C", "C")),
                          substitute = c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE)
                          )

MP_names <- rbind(MP_names_GL, MP_names_FO)

# Export -----

write.csv(MP_names, here("data", "processed", "csv", "MP_names.csv"),
          row.names = FALSE)

saveRDS(MP_names, here("data", "processed", "MP_names.rds"))

## Metadata -----

annotate_csv(MP_names,
         dataset_description = "MP_names is provided in csv and rds formats in /data/processed. The csv file serves as starting point for building the data set, as the workflow pipeline1 retrieves data from Folketingets Open Data Portal based on which MPs are listed in this file. This repository is shipped with a list of all Folketinget MPs that have represented the Faroe Islands and Greenland from October 07, 2004 until the most recent update of this data set. Refer to the documentation for more details.",
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