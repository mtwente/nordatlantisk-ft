# Setup -----
## Packages -----

library(here)

## Create Data -----

cabinets_fo_gl <- data.frame(
  cabinet = c(
    "enoksen_3", "enoksen_4", "enoksen_5", "kleist_1",
    "hammond_1", "hammond_2", "kielsen_0", "kielsen_1-1",
    "kielsen_1-2", "kielsen_2", "kielsen_3", "kielsen_4",
    "kielsen_5", "kielsen_6", "kielsen_7", "egede_1",
    "egede_2", "nielsen_1",
    "kallsberg_2", "eidesgaard_1", "eidesgaard_2",
    "johannesen-k-l_1-1", "johannesen-k-l_1-2",
    "johannesen-k-l_2-1", "johannesen-k-l_2-2",
    "johannesen-a_1", "steig-nielsen_1", "johannesen-a_2"
  ),
  wikidata_id = factor(c(
    "Q99672345", "Q99673310", "Q7604757", "Q7604603",
    "Q12333085", "Q99736342", "Q99736347", "Q18647396",
    "Q23022475", "Q48743208", "Q56863492", "Q95736906",
    "Q60747425", "Q96385892", "Q105834380", "Q106797236",
    "Q111486937", "Q133576206",
    "Q531981", "Q368075", "Q1212499",
    "Q989048", "Q989048", "Q5203949", "Q5203949",
    "Q20972153", "Q70207330", "Q115858267"
  )),
  location = factor(c(
    rep("GL", 18),
    rep("FO", 10)
  )),
  start = as.Date(c(
    "2003-09-13", "2005-12-01", "2007-05-01", "2009-06-12",
    "2013-04-05", "2013-11-05", "2014-10-01", "2014-12-12",
    "2016-02-02", "2016-10-27", "2018-05-15", "2018-10-05",
    "2019-04-09", "2020-05-29", "2021-02-08", "2021-04-23",
    "2022-04-05", "2025-04-07",
    "2002-06-06", "2004-02-03", "2008-02-04",
    "2008-09-26", "2011-04-06", "2011-11-14", "2013-09-09",
    "2015-09-15", "2019-09-16", "2022-12-22"
  )),
  end = as.Date(c(
    "2005-12-01", "2007-05-01", "2009-06-12", "2013-04-05",
    "2013-11-05", "2014-10-01", "2014-12-12", "2016-02-02",
    "2016-10-27", "2018-05-15", "2018-10-05", "2019-04-09",
    "2020-05-29", "2021-02-08", "2021-04-23", "2022-04-05",
    "2025-04-07", NA,
    "2004-02-03", "2008-02-04", "2008-09-26",
    "2011-04-06", "2011-11-14", "2013-09-09", "2015-09-15",
    "2019-09-16", "2022-12-22", NA
  )),
  GL_A  = c(FALSE, TRUE,  TRUE,  FALSE, TRUE,  TRUE,  FALSE, TRUE,  TRUE,  FALSE, TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,  rep(NA, 10)),
  GL_D  = c(FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, TRUE,  rep(NA, 10)),
  GL_IA = c(TRUE,  TRUE,  FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,  TRUE,  TRUE,  rep(NA, 10)),
  GL_KP = c(FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, rep(NA, 10)),
  GL_N  = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,  TRUE,  FALSE, FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE, rep(NA, 10)),
  GL_NQ = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  FALSE, FALSE, FALSE, rep(NA, 10)),
  GL_PI = c(FALSE, FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, rep(NA, 10)),
  GL_SIU= c(TRUE,  TRUE,  TRUE,  FALSE, TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  TRUE,  FALSE, TRUE,  TRUE,  rep(NA, 10)),
  FO_A  = c(rep(NA, 18), TRUE,  TRUE,  FALSE, TRUE,  FALSE, TRUE,  TRUE,  FALSE, TRUE,  FALSE),
  FO_B  = c(rep(NA, 18), FALSE, TRUE,  FALSE, TRUE,  TRUE,  TRUE,  TRUE,  FALSE, TRUE,  FALSE),
  FO_C  = c(rep(NA, 18), FALSE, TRUE,  TRUE,  TRUE,  TRUE,  FALSE, FALSE, TRUE,  FALSE, TRUE),
  FO_D  = c(rep(NA, 18), TRUE,  FALSE, FALSE, FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE),
  FO_E  = c(rep(NA, 18), TRUE,  FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, TRUE,  FALSE, TRUE),
  FO_F  = c(rep(NA, 18), FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE,  FALSE, TRUE),
  FO_H  = c(rep(NA, 18), TRUE,  FALSE, TRUE,  FALSE, FALSE, TRUE,  TRUE,  FALSE, TRUE,  FALSE),
  stringsAsFactors = FALSE
)

## Export -----

write.csv(
  cabinets_fo_gl,
  here("data", "processed", "csv", "cabinets_fo_gl.csv"),
  row.names = FALSE
)

saveRDS(
  cabinets_fo_gl,
  here("data", "processed", "cabinets_fo_gl.rds")
)
