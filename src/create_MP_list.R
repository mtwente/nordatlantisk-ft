# Setup -----
## Packages -----

library(here)

## Template -----

#MP_names <- data.frame(surname = c("Name1", "Name2", "Name3", "Name4", "Name5", ...),
#                       MP_id = factor(c(1,2,3,4,5, ...)),
#                       ...)

## Create Data -----

MP_names_GL <- data.frame(surname = c("Olsvig", "Lund Olsen", "Jakobsen", "Johansen", "Kleist", "Rossen", "Henningsen Heilmann", "Nielsen", "Chemnitz", "Hammond", "Høegh-Dam", "Olsen"),
                         first_name = c("Sara", "Johan", "Doris", "Lars-Emil", "Kuupik", "Sofia", "Juliane", "Nick", "Aaja", "Aleqa", "Aki-Matilda", "Markus E."),
                         MP_id = factor(c(13, 277, 294, 670, 672, 1484, 6689, 14000, 15757, 15758, 18688, 20635)),
                         origin = factor(rep("GL", 12)),
                         party = factor(c("IA", "IA", "SIU", "SIU", "IA", "IA", "IA", "SIU et al.", "IA", "SIU et al.", "SIU", "SIU")),
                         start_date = c(rep(NA, 12)),
                         end_date = c(rep(NA, 12)))

MP_names_FO <-  data.frame(surname = c("Joensen", "Arge", "Hoydal", "Johannesen", "Skaale", "á Fríðriksmørk", "Kallsberg", "Falkenberg"),
                          first_name = c("Edmund", "Magni", "Høgni", "Axel", "Sjúrður", "Annita", "Anfinn", "Anna"),
                          MP_id = factor(c(247, 15881, 1833, 12283, 262, 6684, 3093, 20349)),
                          origin = factor(rep("FO", 8)),
                          party = factor(c("B", "E", "E", "C", "C", "E", "A", "B")),
                          start_date = c(rep(NA, 8)),
                          end_date = c(rep(NA, 8)))

MP_names <- rbind(MP_names_GL, MP_names_FO)

# Export -----

write.csv(MP_names, here("data", "processed", "csv", "MP_names.csv"),
          row.names = FALSE)

saveRDS(MP_names, here("data", "processed", "MP_names.rds"))