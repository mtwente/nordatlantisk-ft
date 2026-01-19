# Setup -----
## Packages -----
library(here)

## Create Data -----

cabinets_fo <- data.frame(
  cabinet = c(
    "kallsberg_2", "eidesgaard_1", "eidesgaard_2",
    "johannesen-k-l_1-1", "johannesen-k-l_1-2",
    "johannesen-k-l_2-1", "johannesen-k-l_2-2",
    "johannesen-a_1", "steig-nielsen_1", "johannesen-a_2"
  ),
  wikidata_id = factor(c(
    "Q531981", "Q368075", "Q1212499",
    "Q989048", "Q989048", "Q5203949", "Q5203949",
    "Q20972153", "Q70207330", "Q115858267"
  )),
  location = factor(c(
    rep("FO", 10)
  )),
  start = as.Date(c(
    "2002-06-06", "2004-02-03", "2008-02-04",
    "2008-09-26", "2011-04-06", "2011-11-14", "2013-09-09",
    "2015-09-15", "2019-09-16", "2022-12-22"
  )),
  end = as.Date(c(
    "2004-02-03", "2008-02-04", "2008-09-26",
    "2011-04-06", "2011-11-14", "2013-09-09", "2015-09-15",
    "2019-09-16", "2022-12-22", NA
  )),
  FO_A  = c(TRUE,  TRUE,  FALSE, TRUE,  FALSE, TRUE,  TRUE,  FALSE, TRUE,  FALSE),
  FO_B  = c(FALSE, TRUE,  FALSE, TRUE,  TRUE,  TRUE,  TRUE,  FALSE, TRUE,  FALSE),
  FO_C  = c(FALSE, TRUE,  TRUE,  TRUE,  TRUE,  FALSE, FALSE, TRUE,  FALSE, TRUE),
  FO_D  = c(TRUE,  FALSE, FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE),
  FO_E  = c(TRUE,  FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, TRUE,  FALSE, TRUE),
  FO_F  = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,  FALSE, TRUE),
  FO_H  = c(TRUE,  FALSE, TRUE,  FALSE, FALSE, TRUE,  TRUE,  FALSE, TRUE,  FALSE),
  stringsAsFactors = FALSE
)

## Export -----

write.csv(
  cabinets_fo,
  here("data", "processed", "csv", "cabinets_fo.csv"),
  row.names = FALSE
)

saveRDS(
  cabinets_fo,
  here("data", "processed", "cabinets_fo.rds")
)
