# Setup -----
## Packages -----

library(here)

## Define MP timeline -----

MP_dates <- do.call(
  rbind,
  list(
    c("Olsvig","Sara","13","GL","IA","2011-09-15","2013-09-08",FALSE),
    c("Olsvig","Sara","13","GL","IA","2013-09-14","2013-10-01",FALSE),
    c("Olsvig","Sara","13","GL","IA","2013-11-19","2014-03-21",FALSE),
    c("Olsvig","Sara","13","GL","IA","2014-04-25","2014-09-15",FALSE),
    c("Olsvig","Sara","13","GL","IA","2015-05-27","2015-06-18",FALSE),
    
    c("Lund Olsen","Johan","277","GL","IA","2013-09-08","2013-09-14",TRUE),
    c("Lund Olsen","Johan","277","GL","IA","2013-10-01","2013-11-19",TRUE),
    c("Lund Olsen","Johan","277","GL","IA","2014-03-21","2014-04-25",TRUE),
    c("Lund Olsen","Johan","277","GL","IA","2014-09-15","2015-05-27",TRUE),
    
    c("Jakobsen","Doris","294","GL","SIU","2009-10-08","2009-11-30",TRUE),
    c("Jakobsen","Doris","294","GL","SIU","2011-09-15","2014-12-16",FALSE),
    c("Jakobsen","Doris","294","GL","SIU","2015-02-11","2015-06-18",FALSE),
    
    c("Johansen","Lars-Emil","670","GL","SIU","2001-11-20","2009-10-08",FALSE),
    c("Johansen","Lars-Emil","670","GL","SIU","2009-11-30","2011-09-15",FALSE),
    
    c("Kleist","Kuupik","672","GL","IA","2001-11-20","2007-04-10",FALSE),
    c("Kleist","Kuupik","672","GL","IA","2007-06-01","2007-11-13",FALSE),
    
    c("Rossen","Sofia","1484","GL","IA","2007-04-10","2007-06-01",TRUE),
    c("Rossen","Sofia","1484","GL","IA","2010-01-12","2010-10-04",TRUE),
    
    c("Henningsen Heilmann","Juliane","6689","GL","IA","2007-11-13","2010-01-12",FALSE),
    c("Henningsen Heilmann","Juliane","6689","GL","IA","2010-10-04","2011-09-15",FALSE),
    
    c("Nielsen","Nick","14000","GL","SIU","2014-12-16","2015-02-11",TRUE),
    
    c("Chemnitz","Aaja","15757","GL","IA","2015-06-18",NA,FALSE),
    
    c("Hammond","Aleqa","15758","GL","SIU","2015-06-18","2016-08-22",FALSE),
    c("Hammond","Aleqa","15758","GL","UF","2016-08-23","2018-04-24",FALSE),
    c("Hammond","Aleqa","15758","GL","NQ","2018-04-25","2019-06-05",FALSE),
    
    c("Høegh-Dam","Aki-Matilda","18688","GL","SIU","2019-06-05","2023-09-22",FALSE),
    c("Høegh-Dam","Aki-Matilda","18688","GL","SIU","2023-10-06","2025-02-07",FALSE),
    c("Høegh-Dam","Aki-Matilda","18688","GL","UF","2025-02-08","2025-02-10",FALSE),
    c("Høegh-Dam","Aki-Matilda","18688","GL","N","2025-02-11","2025-09-19",FALSE),
    c("Høegh-Dam","Aki-Matilda","18688","GL","N","2025-11-14",NA,FALSE),
    
    c("Olsen","Markus E.","20635","GL","SIU","2023-09-22","2023-10-06",TRUE),
    
    c("Kûitse","Elvira","21206","GL","N","2025-09-19","2025-11-14",TRUE),
    
    c("Joensen","Edmund","247","FO","B","1994-09-21","1998-03-11",FALSE),
    c("Joensen","Edmund","247","FO","B","2007-11-13","2007-12-04",FALSE),
    c("Joensen","Edmund","247","FO","B","2007-12-14","2015-06-18",FALSE),
    c("Joensen","Edmund","247","FO","B","2019-06-05","2020-11-03",FALSE),
    c("Joensen","Edmund","247","FO","B","2020-11-10","2021-12-07",FALSE),
    c("Joensen","Edmund","247","FO","B","2021-12-14","2022-11-01",FALSE),
    
    c("Petersen","Lisbeth","918","FO","B","1988-10-06","1988-10-19",TRUE),
    c("Petersen","Lisbeth","918","FO","B","2001-11-20","2005-02-08",FALSE),
    
    c("Arge","Magni","15881","FO","E","2015-07-28","2016-10-17",TRUE),
    c("Arge","Magni","15881","FO","E","2016-12-31","2017-12-10",TRUE),
    c("Arge","Magni","15881","FO","E","2017-12-11","2019-06-05",FALSE),
    
    c("Hoydal","Høgni","1833","FO","E","2001-11-20","2001-12-13",FALSE),
    c("Hoydal","Høgni","1833","FO","E","2004-02-18","2008-02-19",FALSE),
    c("Hoydal","Høgni","1833","FO","E","2008-10-24","2011-09-15",FALSE),
    c("Hoydal","Høgni","1833","FO","E","2015-06-18","2015-07-28",FALSE),
    
    c("Johannesen","Aksel","12283","FO","C","2012-04-20","2012-05-20",TRUE),
    
    c("Skaale","Sjúrður","262","FO","E","2008-02-19","2008-09-09",TRUE),
    c("Skaale","Sjúrður","262","FO","C","2011-09-15","2012-04-20",FALSE),
    c("Skaale","Sjúrður","262","FO","C","2012-05-20","2018-05-07",FALSE),
    c("Skaale","Sjúrður","262","FO","C","2018-05-13","2019-01-15",FALSE),
    c("Skaale","Sjúrður","262","FO","C","2019-01-24","2019-02-28",FALSE),
    c("Skaale","Sjúrður","262","FO","C","2019-03-07","2020-03-17",FALSE),
    c("Skaale","Sjúrður","262","FO","C","2020-03-24","2021-05-16",FALSE),
    c("Skaale","Sjúrður","262","FO","C","2021-05-23","2024-03-05",FALSE),
    c("Skaale","Sjúrður","262","FO","C","2024-03-25",NA,FALSE),
    
    c("á Fríðriksmørk","Annita","6684","FO","E","2008-09-09","2008-10-24",TRUE),
    
    c("Kallsberg","Anfinn","3093","FO","A","2005-02-08","2007-11-13",FALSE),
    
    c("Falkenberg","Anna","20349","FO","B","2022-11-01",NA,FALSE),
    
    c("Jacobsen","Tórbjørn","9780","FO","E","2001-12-14","2004-02-17",TRUE),
    c("Jacobsen","Tórbjørn","9780","FO","E","2016-10-18","2016-12-31",TRUE),
    
    c("Old","Henrik","18545","FO","C","2019-01-15","2019-01-24",TRUE),
    
    c("Johannesen","Kaj Leo","6687","FO","B","2007-12-04","2007-12-14",TRUE),
    
    c("Apol","Barbara Gaardlykke","19142","FO","C","2020-03-17","2020-03-24",TRUE),
    c("Apol","Barbara Gaardlykke","19142","FO","C","2021-05-16","2021-05-23",TRUE),
    c("Apol","Barbara Gaardlykke","19142","FO","C","2024-03-05","2024-03-25",TRUE),
    
    c("Rasmussen","Magnus","19461","FO","B","2020-11-03","2020-11-10",TRUE),
    
    c("Abrahamsen","Helgi","19996","FO","B","2021-12-07","2021-12-14",TRUE),
    
    c("Dam","Rigmor","18614","FO","C","2019-02-28","2019-03-07",TRUE),
    
    c("Hammer","Bjarni","17988","FO","C","2018-05-07","2018-05-13",TRUE)
  )
)

MP_dates <- as.data.frame(MP_dates, stringsAsFactors = FALSE)

colnames(MP_dates) <- c(
  "surname", "firstname", "MP_id",
  "origin", "party",
  "start", "end",
  "substitute"
)

## Type coercion
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
