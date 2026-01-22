# Setup -----
## Packages -----

library(here)

## Define Column Names -----

named_columns <- c(
  "party",
  "full_name",
  "wikidata_id",
  "party_family",
  "colour",
  "origin",
  "left_right",
  "state_market",
  "liberty_authority",
  "anti_pro_eu"
)

## Create Data (row-wise) -----

IA  <- c("IA",  "Inuit Ataqatigiit",      "Q1128374",  "Communist/Socialist", "#AB2328", "GL", 1.3, 1.4, 3.0, 3.3)
N   <- c("N",   "Naleraq",                "Q16856492",  NA,                   "#FF6900", "GL", NA,  NA,  NA,  NA)
NQ  <- c("NQ",  "Nunatta Qitornai",       "Q50802925",  NA,                   "#A1359B", "GL", NA,  NA,  NA,  NA)
SIU <- c("SIU", "Siumut",                 "Q571175",   "Social Democracy",    "#0385FF", "GL", 3.3, 3.5, 3.5, 8.1)
A   <- c("A",   "Fólkaflokkurin",         "Q932342",   "Conservative",        "#347235", "FO", 7.4, 6.4, 6.9, 7.9)
B   <- c("B",   "Sambandsflokkurin",      "Q932400",   "Conservative",        "#00008B", "FO", 7.4, 6.4, 6.9, 7.9)
C   <- c("C",   "Javnaðarflokkurin",      "Q856027",   "Social Democracy",    "#FF0000", "FO", 3.3, 3.5, 3.5, 8.1)
E   <- c("E",   "Tjóðveldi",              "Q750962",   "Communist/Socialist", "#D2DD3D", "FO", 1.3, 1.4, 3.0, 3.3)

## Bind rows -----

political_parties <- rbind(
  IA, N, NQ, SIU, A, B, C, E
)

## Convert to data frame and name columns -----

political_parties <- as.data.frame(
  political_parties,
  stringsAsFactors = FALSE
)

### Apply pre-defined names -----
colnames(political_parties) <- named_columns

## Coerce column types -----

political_parties$party          <- factor(political_parties$party)
political_parties$wikidata_id    <- factor(political_parties$wikidata_id)
political_parties$party_family   <- factor(political_parties$party_family)
political_parties$origin         <- factor(political_parties$origin)

political_parties$left_right        <- as.numeric(political_parties$left_right)
political_parties$state_market      <- as.numeric(political_parties$state_market)
political_parties$liberty_authority <- as.numeric(political_parties$liberty_authority)
political_parties$anti_pro_eu       <- as.numeric(political_parties$anti_pro_eu)

## Export -----

write.csv(
  political_parties,
  here("data", "processed", "csv", "political_parties.csv"),
  row.names = FALSE
)

saveRDS(
  political_parties,
  here("data", "processed", "political_parties.rds")
)
