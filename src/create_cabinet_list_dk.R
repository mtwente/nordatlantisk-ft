# Setup -----
## Packages -----
library(here)

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
  cabinets,
  here("data", "processed", "csv", "cabinets_dk.csv"),
  row.names = FALSE
)

saveRDS(
  cabinets,
  here("data", "processed", "cabinets_dk.rds")
)
