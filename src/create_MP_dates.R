# Setup -----
## Packages -----
library(here)

## External Functions -----
source(here("src", "annotate_csv.R"), local = TRUE)

## Define MP timeline -----

MP_dates <- do.call(
  rbind,
  list(
    c("olsvig_1", "Olsvig","Sara","13","GL","IA","2011-09-15","2013-09-08",FALSE),
    c("olsvig_2", "Olsvig","Sara","13","GL","IA","2013-09-14","2013-10-01",FALSE),
    c("olsvig_3", "Olsvig","Sara","13","GL","IA","2013-11-19","2014-03-21",FALSE),
    c("olsvig_4", "Olsvig","Sara","13","GL","IA","2014-04-25","2014-09-15",FALSE),
    c("olsvig_5", "Olsvig","Sara","13","GL","IA","2015-05-27","2015-06-18",FALSE),
    
    c("lund-olsen_1", "Lund Olsen","Johan","277","GL","IA","2013-09-08","2013-09-14",TRUE),
    c("lund-olsen_2", "Lund Olsen","Johan","277","GL","IA","2013-10-01","2013-11-19",TRUE),
    c("lund-olsen_3", "Lund Olsen","Johan","277","GL","IA","2014-03-21","2014-04-25",TRUE),
    c("lund-olsen_4", "Lund Olsen","Johan","277","GL","IA","2014-09-15","2015-05-27",TRUE),
    
    c("jakobsen_1", "Jakobsen","Doris","294","GL","SIU","2009-10-08","2009-11-30",TRUE),
    c("jakobsen_2", "Jakobsen","Doris","294","GL","SIU","2011-09-15","2014-12-16",FALSE),
    c("jakobsen_3", "Jakobsen","Doris","294","GL","SIU","2015-02-11","2015-06-18",FALSE),
    
    c("johansen_1", "Johansen","Lars-Emil","670","GL","SIU","2001-11-20","2009-10-08",FALSE),
    c("johansen_2", "Johansen","Lars-Emil","670","GL","SIU","2009-11-30","2011-09-15",FALSE),
    
    c("kleist_1", "Kleist","Kuupik","672","GL","IA","2001-11-20","2007-04-10",FALSE),
    c("kleist_2", "Kleist","Kuupik","672","GL","IA","2007-06-01","2007-11-13",FALSE),
    
    c("rossen_1", "Rossen","Sofia","1484","GL","IA","2007-04-10","2007-06-01",TRUE),
    c("rossen_2", "Rossen","Sofia","1484","GL","IA","2010-01-12","2010-10-04",TRUE),
    
    c("henningsen-heilmann_1", "Henningsen Heilmann","Juliane","6689","GL","IA","2007-11-13","2010-01-12",FALSE),
    c("henningsen-heilmann_2", "Henningsen Heilmann","Juliane","6689","GL","IA","2010-10-04","2011-09-15",FALSE),
    
    c("nielsen_1", "Nielsen","Nick","14000","GL","SIU","2014-12-16","2015-02-11",TRUE),
    
    c("chemnitz_1", "Chemnitz","Aaja","15757","GL","IA","2015-06-18",NA,FALSE),
    
    c("hammond_1", "Hammond","Aleqa","15758","GL","SIU","2015-06-18","2016-08-22",FALSE),
    c("hammond_2", "Hammond","Aleqa","15758","GL","UF","2016-08-23","2018-04-24",FALSE),
    c("hammond_3", "Hammond","Aleqa","15758","GL","NQ","2018-04-25","2019-06-05",FALSE),
    
    c("hoegh-dam_1", "Høegh-Dam","Aki-Matilda","18688","GL","SIU","2019-06-05","2023-09-22",FALSE),
    c("hoegh-dam_2", "Høegh-Dam","Aki-Matilda","18688","GL","SIU","2023-10-06","2025-02-07",FALSE),
    c("hoegh-dam_3", "Høegh-Dam","Aki-Matilda","18688","GL","UF","2025-02-08","2025-02-10",FALSE),
    c("hoegh-dam_4", "Høegh-Dam","Aki-Matilda","18688","GL","N","2025-02-11","2025-09-19",FALSE),
    c("hoegh-dam_5", "Høegh-Dam","Aki-Matilda","18688","GL","N","2025-11-14",NA,FALSE),
    
    c("olsen_1", "Olsen","Markus E.","20635","GL","SIU","2023-09-22","2023-10-06",TRUE),
    
    c("kuitse_1", "Kûitse","Elvira","21206","GL","N","2025-09-19","2025-11-14",TRUE),
    
    c("joensen_1", "Joensen","Edmund","247","FO","B","1994-09-21","1998-03-11",FALSE),
    c("joensen_2", "Joensen","Edmund","247","FO","B","2007-11-13","2007-12-04",FALSE),
    c("joensen_3", "Joensen","Edmund","247","FO","B","2007-12-14","2015-06-18",FALSE),
    c("joensen_4", "Joensen","Edmund","247","FO","B","2019-06-05","2020-11-03",FALSE),
    c("joensen_5", "Joensen","Edmund","247","FO","B","2020-11-10","2021-12-07",FALSE),
    c("joensen_6", "Joensen","Edmund","247","FO","B","2021-12-14","2022-11-01",FALSE),
    
    c("petersen_1", "Petersen","Lisbeth","918","FO","B","1988-10-06","1988-10-19",TRUE),
    c("petersen_2", "Petersen","Lisbeth","918","FO","B","2001-11-20","2005-02-08",FALSE),
    
    c("arge_1", "Arge","Magni","15881","FO","E","2015-07-28","2016-10-17",TRUE),
    c("arge_2", "Arge","Magni","15881","FO","E","2016-12-31","2017-12-10",TRUE),
    c("arge_3", "Arge","Magni","15881","FO","E","2017-12-11","2019-06-05",FALSE),
    
    c("hoydal_1", "Hoydal","Høgni","1833","FO","E","2001-11-20","2001-12-13",FALSE),
    c("hoydal_2", "Hoydal","Høgni","1833","FO","E","2004-02-18","2008-02-19",FALSE),
    c("hoydal_3", "Hoydal","Høgni","1833","FO","E","2008-10-24","2011-09-15",FALSE),
    c("hoydal_4", "Hoydal","Høgni","1833","FO","E","2015-06-18","2015-07-28",FALSE),
    
    c("johannesen-a_1", "Johannesen","Aksel","12283","FO","C","2012-04-20","2012-05-20",TRUE),
    
    c("skaale_1", "Skaale","Sjúrður","262","FO","E","2008-02-19","2008-09-09",TRUE),
    c("skaale_2", "Skaale","Sjúrður","262","FO","C","2011-09-15","2012-04-20",FALSE),
    c("skaale_3", "Skaale","Sjúrður","262","FO","C","2012-05-20","2018-05-07",FALSE),
    c("skaale_4", "Skaale","Sjúrður","262","FO","C","2018-05-13","2019-01-15",FALSE),
    c("skaale_5", "Skaale","Sjúrður","262","FO","C","2019-01-24","2019-02-28",FALSE),
    c("skaale_6", "Skaale","Sjúrður","262","FO","C","2019-03-07","2020-03-17",FALSE),
    c("skaale_7", "Skaale","Sjúrður","262","FO","C","2020-03-24","2021-05-16",FALSE),
    c("skaale_8", "Skaale","Sjúrður","262","FO","C","2021-05-23","2024-03-05",FALSE),
    c("skaale_9", "Skaale","Sjúrður","262","FO","C","2024-03-25",NA,FALSE),
    
    c("a-fridriksmork_1", "á Fríðriksmørk","Annita","6684","FO","E","2008-09-09","2008-10-24",TRUE),
    
    c("kallsberg_1", "Kallsberg","Anfinn","3093","FO","A","2005-02-08","2007-11-13",FALSE),
    
    c("falkenberg_1", "Falkenberg","Anna","20349","FO","B","2022-11-01",NA,FALSE),
    
    c("jacobsen_1", "Jacobsen","Tórbjørn","9780","FO","E","2001-12-14","2004-02-17",TRUE),
    c("jacobsen_2", "Jacobsen","Tórbjørn","9780","FO","E","2016-10-18","2016-12-31",TRUE),
    
    c("old_1", "Old","Henrik","18545","FO","C","2019-01-15","2019-01-24",TRUE),
    
    c("johannesen-k-l_1", "Johannesen","Kaj Leo","6687","FO","B","2007-12-04","2007-12-14",TRUE),
    
    c("apol_1", "Apol","Barbara Gaardlykke","19142","FO","C","2020-03-17","2020-03-24",TRUE),
    c("apol_2", "Apol","Barbara Gaardlykke","19142","FO","C","2021-05-16","2021-05-23",TRUE),
    c("apol_3", "Apol","Barbara Gaardlykke","19142","FO","C","2024-03-05","2024-03-25",TRUE),
    
    c("rasmussen_1", "Rasmussen","Magnus","19461","FO","B","2020-11-03","2020-11-10",TRUE),
    
    c("abrahamsen_1", "Abrahamsen","Helgi","19996","FO","B","2021-12-07","2021-12-14",TRUE),
    
    c("dam_1", "Dam","Rigmor","18614","FO","C","2019-02-28","2019-03-07",TRUE),
    
    c("hammer_1", "Hammer","Bjarni","17988","FO","C","2018-05-07","2018-05-13",TRUE)
  )
)

MP_dates <- as.data.frame(MP_dates, stringsAsFactors = FALSE)

colnames(MP_dates) <- c(
  "period_id",
  "surname", "first_name", "MP_id",
  "origin", "party",
  "start", "end",
  "substitute"
)

## Type coercion
MP_dates$period_id  <- factor(MP_dates$period_id) 
MP_dates$MP_id      <- factor(MP_dates$MP_id)
MP_dates$origin     <- factor(MP_dates$origin)
MP_dates$party      <- factor(MP_dates$party)
MP_dates$substitute <- as.logical(MP_dates$substitute)

MP_dates$start <- as.Date(MP_dates$start)
MP_dates$end   <- as.Date(MP_dates$end)

## Export
write.csv(
  MP_dates,
  here("data", "processed", "csv", "MP_dates.csv"),
  row.names = FALSE
)

saveRDS(
  MP_dates,
  here("data", "processed", "MP_dates.rds")
)

## Metadata -----

annotate_csv(MP_dates,
         dataset_description = "MP_dates is provided in csv and rds formats in /data/processed. This dataset includes detailed information on membership timelines of MPs in Folketinget. Refer to the documentation for more details.",
         column_title = c(
           "Membership Period ID",
           "Surname(s)",
           "First Name(s)",
           "MP ID",
           "Origin",
           "Party",
           "Start Date",
           "End Date",
           "Substitute MP"
           ),
         column_description = c(
           "Unique identifier for each membership period",
           "Surname(s) of the MP. Names are spelled according to standardised orthography and, in terms of morphology, in nominative (Faroese) resp. absolutive (Greenlandic) case",
           "First Name(s) of the MP. Names are spelled according to standardised orthography and, in terms of morphology, in nominative (Faroese) resp. absolutive (Greenlandic) case",
           "Each MP is assigned an ID by Folketingets åbne data service (ODA). Each MP_id thus is a unique identifier for one member of Folketinget",
           "Geographical origin of the MP, using ISO 3166-2 codes",
           "Political Party the MP is member of at the time of this vote, using the common abbreviation for Greenlandic Parties and the party letter code (Bogstavsbetegnelse) for Faroese parties",
           "Date of the beginning of a parliamentary membership period",
           "Date of the end of parliamentary membership period",
           "Boolean indicating whether the MP served Folketinget as a substitute member for another MP who went on leave"
           ))
