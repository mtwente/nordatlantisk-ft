# Codebook: nordatlantisk-ft

- [Introduction](#introduction)
- [File and Variable Descriptions](#file-and-variable-descriptions)
  - [MP_names](#mp_names)
  - [northatlantic_votes](#northatlantic_votes)
  - [northatlantic_votes_raw](#northatlantic_votes_raw)
  - [ballot_results_ft](#ballot_results_ft)
  - [ballot_info_raw](#ballot_info_raw)
  - [northatlantic_ft](#northatlantic_ft)
- [References](#references)

# Introduction

This codebook provides descriptions of the `nordatlantisk-ft` data set, i.e. of all files in [`../data/`](../data). Variables are described for each file individually with information on connections to other variables within the pipeline to create the data set. All data, unless otherwise specified, is retrieved from the records of Folketinget[^folketinget-1], the parliament of Denmark.

[^folketinget-1]: Folketinget. 2024. “Folketingets Åbne Data.” <https://oda.ft.dk>.

All data is available in `rds` format that can be read in an R Session via `readRDS()`. Where data is also available in `csv` format, the tabular metadata is provided in `json` files at [`../data/processed/csv`](../data/processed/csv) according to the W3C Metadata Vocabulary for Tabular Data[^w3c-2].

[^w3c-2]: W3C. 2015. “W3C Recommendation: Metadata Vocabulary for Tabular Data.” <https://www.w3.org/TR/tabular-metadata/>.

# File and Variable Descriptions

## MP_names

`MP_names` is provided in `csv` and `rds` formats in [`../data/processed`](../data/processed). The `csv` file serves as starting point for building the data set, as the workflow pipeline[^codebook-1] retrieves data from [Folketingets Open Data Portal](https://oda.ft.dk) based on which MPs are listed in this file. This repository is shipped with a list of all Folketinget MPs that have represented the Faroe Islands and Greenland from 2004 until January 2024, which results in 20 MPs.

[^codebook-1]: See [`../README.md`](../README.md) or [`../_targets.R`](../_targets.R)

```r
head(MP_names)
```

```
##      surname first_name MP_id origin party start_date end_date
## 1     Olsvig       Sara    13     GL    IA         NA       NA
## 2 Lund Olsen      Johan   277     GL    IA         NA       NA
## 3   Jakobsen      Doris   294     GL   SIU         NA       NA
## 4   Johansen  Lars-Emil   670     GL   SIU         NA       NA
## 5     Kleist     Kuupik   672     GL    IA         NA       NA
## 6     Rossen      Sofia  1484     GL    IA         NA       NA
```

Descriptions of all variables in `MP_names` are provided in the following sections. The only variable necessary to execute the workflow is stored as [`MP_names$MP_id`](#mp_namesmp_id).

### MP_names$surname

All surname(s) are stored as values of the type `character`. Names are spelled according to standardised orthography and, in terms of morphology, in nominative (Faroese) resp. absolutive (Greenlandic) case. Because there may be multiple MPs with the same surname(s), refer to [`MP_names$MP_id`](#mp_namesmp_id) instead for reliable identification.

This column is not necessary for successfully executing the workflow pipeline, but it can be used to map MP names to the corresponding IDs for increased readability of resulting plots.

```r
head(MP_names$surname)
```

```
## [1] "Olsvig"     "Lund Olsen" "Jakobsen"   "Johansen"   "Kleist"
## [6] "Rossen"
```

### MP_names$first_name

All first names are stored as values of the type `character`. Names are spelled according to standardised orthography and, morphologically, in nominative (Faroese) resp. absolutive (Greenlandic) case. Because there may be multiple MPs with the same first name(s), refer to [`MP_names$MP_id`](#MP_names_MP_id) instead for reliable identification.

This column is not necessary for successfully executing the workflow pipeline, but it can be used to map MPs’ names to the corresponding IDs for increased readability of resulting plots.

```r
head(MP_names$first_name)
```

```
## [1] "Sara"      "Johan"     "Doris"     "Lars-Emil" "Kuupik"    "Sofia"
```

### MP_names$MP_id

Each MP is assigned an ID by [Folketingets åbne data service (ODA)](https://www.ft.dk/dokumenter/aabne_data). Each `MP_id` thus is a unique identifier for one member of Folketinget. All IDs are stored as values of the type `integer` as `factor` variable. It is possible to use these IDs e.g. for querying the [the online database](https://oda.ft.dk) to retrieve documents that relate to a given MP or to find out which parliamentary processes this MP has been engaged in.

`MP_id` is the only necessary column in `MP_names` for successfully executing the workflow pipeline.

```r
head(MP_names$MP_id)
```

```
## [1] 13   277  294  670  672  1484
## 20 Levels: 13 277 294 670 672 1484 6689 14000 15757 15758 18688 20635 ... 20349
```

This variable corresponds to the `aktørid` variable and the `Aktør` resource in [the Folketing online database](https://oda.ft.dk). Note that in Folketinget’s data model, ministries, parliamentary commissions, NGOs etc. are also listed as `Aktør` with their resp. `aktørid`.

### MP_names$origin

`origin` indicates whether an MP was elected in either Greenland (`GL`) or the Faroe Islands (`FO`). This variable is stored as value of the type `integer` as `factor` variable. Note that this only indicates where the MP in question ran for office. MPs with ties to Greenland or the Faroe Islands who won a Folketinget mandate in a continental election district are thus not part of this data set, as they are not considered _Northatlantic_ MPs.

```r
summary(MP_names$origin)
```

```
## GL FO
## 12  8
```

### MP_names$party

The political party that each MP belongs to is stored as value of the type `integer` as `factor` variable. As per January 2024, there have been two MPs from Greenland who left their party – Siumut, in both cases – during their time in office. For now, these cases are stored as a separate character string (`SIU et al.`).

```r
summary(MP_names$party)
```

```
##         IA        SIU SIU et al.          A          B          C          E
##          6          4          2          1          2          2          3
```

Since 2004, Greenlandic MPs have belonged to two political parties while MPs from Faroe Islands were members of four different political parties. They are listed below with additional information on their positions from the ParlGov dataset[^doering-4].

[^doering-4]: Döring, Holger, Constantin Huber, and Philip Manow. 2022. “ParlGov 2022 Release.” Harvard Dataverse. <https://doi.org/10.7910/DVN/UKILBE>.

| Party | Full Name         |    Party Family     | Origin | Left-Right | State-Market | Liberty-Authority | Anti-Pro EU |
| :---- | :---------------- | :-----------------: | :----: | :--------: | :----------: | :---------------: | :---------: |
| IA    | Inuit Ataqatigiit | Communist/Socialist |   GL   |    1.3     |     1.4      |         3         |     3.3     |
| SIU   | Siumut            |  Social Democracy   |   GL   |    3.3     |     3.5      |        3.5        |     8.1     |
| A     | Fólkaflokkurin    |    Conservative     |   FO   |    7.4     |     6.4      |        6.9        |     7.9     |
| B     | Sambandsflokkurin |    Conservative     |   FO   |    7.4     |     6.4      |        6.9        |     7.9     |
| C     | Javnaðarflokkurin |  Social Democracy   |   FO   |    3.3     |     3.5      |        3.5        |     8.1     |
| E     | Tjóðveldi         | Communist/Socialist |   FO   |    1.3     |     1.4      |         3         |     3.3     |

See Ackrén 2015[^ackren-5] for an analysis of the development of Greenlandic political parties until 2014. For overviews of the Faroese political party system see West 2022 in Faroese[^west-6] and West 2020 in Danish[^west-7]. Harder 2022[^harder-8] provides a list of all Greenlandic and Faroese MPs and their party association(s) going back until 1953.

[^ackren-5]: Ackrén, Maria. 2015. “The Political Parties in Greenland and Their Development.” In _States Falling Apart? Secessionist and Autonomy Movements in Europe_, 317–35. Publications of the Institute of Federalism Fribourg University Switzerland 10. Bern: Stämpfli Verlag.
[^west-7]: West, Hallbera. 2020. “Færøsk Politik – Mellem Gamle Politiske Traditioner Og Ny Forvaltningspraksis.” _Økonomi & Politik_ 93 (4): 11–23. <https://doi.org/10.7146/okonomi-og-politik.v93i4.123410>.
[^west-6]: West, Hallbera. 2022. “Skipanarligar Fortreytir Og Føroysk Stjórnarviðurskifti.” _Fróðskaparrit_ 68 (December): 87–110. <https://ojs.setur.fo/index.php/frit/article/view/304>.
[^harder-8]: Harder, Mette Marie Stæhr. 2022. “Supplerende Materiale: Færøske Og Grønlandske Mandater i Folketinget.” _Politica_ 54 (1). <https://politica.dk/fileadmin/politica/Dokumenter/politica_54_1/harder_supplerende_materiale.pdf>.

### MP_names$start_date

For now, `start_date` is an empty placeholder variable. It will provide information on which date the MPs joined Folketinget.

```r
head(MP_names$start_date)
```

```
## [1] NA NA NA NA NA NA
```

### MP_names$end_date

For now, `end_date` is an empty placeholder variable. It will provide information on which date the MPs left Folketinget.

```r
head(MP_names$end_date)
```

```
## [1] NA NA NA NA NA NA
```

---

## northatlantic_votes

`northatlantic_votes` is provided as `rds` file in [`../data/processed/`](../data/processed). After all votes cast by the MPs specified in [`MP_names`](#mp_names) are downloaded, they are processed and then stored in this file. The unprocessed [raw data](#northatlantic_votes_raw) is available as `csv` file in [`../data/raw/`](../data/raw). As per January 2024, `northatlantic_votes.rds` contains 36876 observations of 4 variables.

```r
head(northatlantic_votes)
```

```
##   vote_id vote_type_id ballot_id MP_id
## 1     177            3         1    13
## 2     356            3         2    13
## 3  113827            3       283    13
## 4  114006            3       284    13
## 5  114185            3       285    13
## 6  114364            3       286    13
```

Descriptions of all variables in `northatlantic_votes` are provided in the following sections.

### northatlantic_votes$vote_id

All votes cast in Folketinget are assigned an ID by [Folketingets åbne data service (ODA)](https://www.ft.dk/dokumenter/aabne_data). Each vote ID is thus a unique identifier for one vote cast in Folketinget. All IDs are stored as values of the type `integer` as `factor` variable.

This variable corresponds to the `id` variable and the `Stemme` resource in [the Folketing online database](https://oda.ft.dk).

```r
head(northatlantic_votes$vote_id)
```

```
## [1] 177    356    113827 114006 114185 114364
## 36876 Levels: 1000151 1000154 1000159 1000160 1000330 1000333 1000338 ... 999978
```

### northatlantic_votes$vote_type_id

All votes cast in Folketinget are recorded using numeric values that correspond to the MP’s decision. All Vote Type IDs are stored as values of the type `integer` as `factor` variable.

| ID  | Result                 | English    |       n |
| :-- | :--------------------- | :--------- | ------: |
| 1   | for                    | for        |   `319` |
| 2   | imod                   | against    |   `241` |
| 3   | fravær                 | absence    | `36184` |
| 4   | hverken for eller imod | abstention |   `132` |

This variable corresponds to the `typeid` variable and the `Stemmetype` resource in [the Folketing online database](https://oda.ft.dk).

```r
head(northatlantic_votes$vote_type_id)
```

```
## [1] 3 3 3 3 3 3
## Levels: 1 2 3 4
```

### northatlantic_votes$ballot_id

All ballot procedures in Folketinget are assigned an ID by [Folketingets åbne data service (ODA)](https://www.ft.dk/dokumenter/aabne_data). Each ballot ID is thus a unique identifier for one ballot in Folketinget. All IDs are stored as values of the type `integer` as `factor` variable.

This variable corresponds to the [`ballot_results_ft$ballot_id`](#ballot_results_ftballot_id) variable and the `Afstemning` resource in [the Folketing online database](https://oda.ft.dk). Take care not to confuse `ballot_id` with [`ballot_results_ft$ballot_nr`](#ballot_results_ftballot_nr).

```r
head(northatlantic_votes$ballot_id)
```

```
## [1] 1   2   283 284 285 286
## 9317 Levels: 1 10 100 1000 1001 1002 1003 1004 1005 1006 1007 1008 1009 ... 999
```

### northatlantic_votes$MP_id

See [`MP_names$MP_id`](#mp_namesmp_id).

```r
head(northatlantic_votes$MP_id)
```

```
## [1] 13 13 13 13 13 13
## 20 Levels: 12283 13 14000 1484 15757 15758 15881 1833 18688 20349 20635 ... 672
```

---

## northatlantic_votes_raw

`northatlantic_votes_raw` is provided as `csv` file in [`../data/raw/`](../data/raw). It contains the downloaded data on voting records before any preprocessing. The [processed data](#northatlantic_votes) is available as `rds` file in [`../data/processed`](../data/processed). As per January 2024, `northatlantic_votes_raw.csv` contains 36876 observations of 5 variables.

```r
head(northatlantic_votes_raw)
```

```
##       id typeid afstemningid aktørid         opdateringsdato
## 1    177      3            1      13 2014-09-09T09:05:59.653
## 2    356      3            2      13 2014-09-09T09:25:05.717
## 3 113827      3          283      13     2014-09-22T15:44:12
## 4 114006      3          284      13     2014-09-22T15:44:12
## 5 114185      3          285      13     2014-09-22T15:44:12
## 6 114364      3          286      13     2014-09-22T15:44:12
```

Descriptions of all variables in `northatlantic_votes_raw` are provided in the following sections.

### northatlantic_votes_raw$id

See [`northatlantic_votes$vote_id`](#northatlantic_votesvote_id). In the raw data, `id` is stored as `integer` value.

```r
head(northatlantic_votes_raw$id)
```

```
## [1]    177    356 113827 114006 114185 114364
```

### northatlantic_votes_raw$typeid

See [`northatlantic_votes$vote_type_id`](#northatlantic_votesvote_type_id). In the raw data, `typeid` is stored as `integer` value.

```r
head(northatlantic_votes_raw$typeid)
```

```
## [1] 3 3 3 3 3 3
```

### northatlantic_votes_raw$afstemningid

See [`northatlantic_votes$ballot_id`](#northatlantic_votesballot_id). In the raw data, `afstemningid` is stored as `integer` value.

Take care not to confuse `afstemningid` with [`ballot_results_ft$ballot_nr`](#ballot_results_ftballot_nr).

```r
head(northatlantic_votes_raw$afstemningid)
```

```
## [1]   1   2 283 284 285 286
```

### northatlantic_votes_raw$opdateringsdato

For all records kept in [the Folketing online database](https://oda.ft.dk), the time stamp of its last update is stored in `opdateringsdato`. All dates are stored as values of the type `character`. The time stamps are formatted as `%Y-%m-%dT%T`, with some values even at split second level.

This variable is eliminated from [`northatlantic_votes`](#northatlantic_votes) as a result of data processing.

```r
head(northatlantic_votes_raw$opdateringsdato)
```

```
## [1] "2014-09-09T09:05:59.653" "2014-09-09T09:25:05.717"
## [3] "2014-09-22T15:44:12"     "2014-09-22T15:44:12"
## [5] "2014-09-22T15:44:12"     "2014-09-22T15:44:12"
```

---

## ballot_results_ft

`ballot_results_ft` is provided as `rds` file in [`../data/processed/`](../data/processed). After all ballots are downloaded, they are processed and then stored in this file. The unprocessed [raw data](#ballot_info_raw) is available as `csv` file in [`../data/raw/`](../data/raw). As per January 2024, `ballot_results_ft.rds` contains 9469 observations of 13 variables.

```r
str(ballot_results_ft)
```

```
## 'data.frame':    9469 obs. of  13 variables:
##  $ ballot_id           : Factor w/ 9469 levels "1","10","100",..: 7752 7753 7754 7755 7067 7068 7069 7070 7071 7072 ...
##  $ meeting_id          : Factor w/ 942 levels "10231","10232",..: 1 2 3 3 4 4 5 6 6 7 ...
##  $ ballot_pass         : logi  FALSE TRUE TRUE TRUE TRUE FALSE ...
##  $ ballot_date         : Date, format: "2020-03-12" "2020-03-12" ...
##  $ ft_for              : num  3 95 95 95 92 12 92 96 96 98 ...
##  $ ft_against          : num  92 0 0 0 0 81 0 0 0 0 ...
##  $ ft_abstention       : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ ft_absent           : num  84 84 84 84 87 86 87 83 83 81 ...
##  $ ft_process_id       : Factor w/ 7024 levels "100011","100025",..: 3093 3094 3095 3096 3036 3098 3099 3076 3100 3104 ...
##  $ ballot_nr           : Factor w/ 745 levels "1","10","100",..: 186 187 188 189 191 192 193 194 195 196 ...
##  $ ballot_type_id      : Factor w/ 4 levels "1","2","3","4": 4 1 1 1 1 4 1 1 1 1 ...
##  $ comment             : chr  NA NA NA NA ...
##  $ ballot_result_string: chr  "Forslaget blev forkastet. For stemte 3 (NB, Simon Emil Ammitzbøll-Bille (UFG)), imod stemte 92 (S, V, DF, RV, S"| __truncated__ "Forslaget blev vedtaget. For stemte 95 (S, V, DF, RV, SF, EL, KF, NB, LA, Simon Emil Ammitzbøll-Bille (UFG), Su"| __truncated__ "Forslaget blev vedtaget. For stemte 95 (S, V, DF, RV, SF, EL, KF, NB, LA, Sikandar Siddique (UFG), Uffe Elbæk ("| __truncated__ "Forslaget blev vedtaget. For stemte 95 (S, V, DF, RV, SF, EL, KF, NB, LA, Sikandar Siddique (UFG), Uffe Elbæk ("| __truncated__ ...
```

Descriptions of all variables in `ballot_results_ft` are provided in the following sections.

### ballot_results_ft$ballot_id

See [northatlantic_votes$ballot_id](#northatlantic_votesballot_id). Take care not to confuse `ballot_id` with [`ballot_nr`](#ballot_results_ftballot_nr).

```r
head(ballot_results_ft$ballot_id)
```

```
## [1] 8042 8043 8044 8045 7425 7426
## 9469 Levels: 1 10 100 1000 1001 1002 1003 1004 1005 1006 1007 1008 1009 ... 999
```

### ballot_results_ft$meeting_id

All meetings in Folketinget are assigned an ID by [Folketingets åbne data service (ODA)](https://www.ft.dk/dokumenter/aabne_data). Each meeting ID is thus a unique identifier for one meeting in Folketinget. All IDs are stored as values of the type `integer` as `factor` variable.

This variable corresponds to the [`mødeid`](#ballot_info_rawmødeid) variable and the `Møde` resource in [the Folketing online database](https://oda.ft.dk).

This variable is eliminated when joining `ballot_results_ft` and `northatlantic_votes` to [`northatlantic_ft`](#northatlantic_ft).

```r
head(ballot_results_ft$meeting_id)
```

```
## [1] 10231 10232 10237 10237 10244 10244
## 942 Levels: 10231 10232 10237 10244 10245 10249 10254 10259 10272 ... 9817
```

### ballot_results_ft$ballot_pass

The result of all ballots in Folketinget is stored in `ballot_pass` as `logical` variable. If parliament votes in favor of a proposal, it passes and `ballot_pass` is assigned `TRUE`; if parliament votes a proposal down, it does not pass and `ballot_pass` is assigned `FALSE`.

This variable corresponds to the [`vedtaget`](#ballot_info_rawvedtaget) variable in the `Afstemning` resource in [the Folketing online database](https://oda.ft.dk).

```r
head(ballot_results_ft$ballot_pass)
```

```
## [1] FALSE  TRUE  TRUE  TRUE  TRUE FALSE
```

### ballot_results_ft$ballot_date

The date on which each ballot takes place in Folketinget is stored as value of the type `double`. Calendar information is formatted as `%Y-%m-%d`, the earliest entry being from `2004-10-07` and the most recent entry from `2023-12-21` as per January 2024.

This variable is added to the data using the [`get_meeting_dates()`](../src/targets/get_meeting_dates.R) function.

```r
head(ballot_results_ft$ballot_date)
```

```
## [1] "2020-03-12" "2020-03-12" "2020-03-17" "2020-03-17" "2020-03-19"
## [6] "2020-03-19"
```

### ballot_results_ft$ft_for

In `ft_for`, the number of votes cast in favor of a proposal is stored as `numeric` value of the type `double`. Since the record keeping of Folketinget is inconsistent regarding the coding of ballot results, values for this variable are calculated in two steps. First, using the retrieved raw data, [`get_missing_info()`](../src/targets/get_missing_info.R) sums up all recorded individual votes in favor of the proposal using the `switch()` function on every row where [`ballot_info_raw$typeid`](#ballot_info_rawtypeid) equals `1`. The results of a considerable share of ballots are recorded only using [a – Danish – character string](#ballot_results_ftcomment) instead of in a list of votes. In these cases, the number of votes in favor of those proposals is extracted with [`clean_ballot_results()`](../src/targets/clean_ballot_results.R) using the `strex` package and then added to the number of approving votes from the first step.

The maximum value stored in `ft_for` is `162` and the minimum value stored in `ft_for` is `0`. As the total number of MPs in Folketinget is 179, the value of `ft_for` cannot be greater than `179`.

```r
head(ballot_results_ft$ft_for)
```

```
## [1]  3 95 95 95 92 12
```

### ballot_results_ft$ft_against

In `ft_against`, the number of votes cast against a proposal is stored as `numeric` value of the type `double`. Since the record keeping of Folketinget is inconsistent regarding the coding of ballot results, values for this variable are calculated in two steps. First, using the retrieved raw data, [`get_missing_info()`](../src/targets/get_missing_info.R) sums up all recorded individual votes in favor of the proposal using the `switch()` function on every row where [`ballot_info_raw$typeid`](#ballot_info_rawtypeid) equals `2`. The results of a considerable share of ballots are recorded only using [a – Danish – character string](#comment) instead of in a list of votes. In these cases, the number of no-votes is extracted with [`clean_ballot_results()`](../src/targets/clean_ballot_results.R) using the `strex` package and then added to the number of no-votes from the first step.

The maximum value stored in `ft_against` is `124` and the minimum value stored in `ft_against` is `0`. As the total number of MPs in Folketinget is 179, the value of `ft_against` cannot be greater than `179`.

```r
head(ballot_results_ft$ft_against)
```

```
## [1] 92  0  0  0  0 81
```

### ballot_results_ft$ft_abstention

In `ft_abstention`, the number of abstaining votes is stored as `numeric` value of the type `double`. Since the record keeping of Folketinget is inconsistent regarding the coding of ballot results, values for this variable are calculated in two steps. First, using the retrieved raw data, [`get_missing_info()`](../src/targets/get_missing_info.R) sums up all recorded individual abstaining votes using the `switch()` function on every row where [`ballot_info_raw$typeid`](#ballot_info_rawtypeid) equals `4`. The results of a considerable share of ballots are recorded only using [a – Danish – character string](#ballot_results_ftcomment) instead of in a list of votes. In these cases, the number of abstentions is extracted with [`clean_ballot_results()`](../src/targets/clean_ballot_results.R) using the `strex` package and then added to the number of abstaining votes from the first step.

The maximum value stored in `ft_abstention` is `160` and the minimum value stored in `ft_abstention` is `0`. As the total number of MPs in Folketinget is 179, the value of `ft_abstention` cannot be greater than `179`.

```r
head(ballot_results_ft$ft_abstention)
```

```
## [1] 0 0 0 0 0 0
```

### ballot_results_ft$ft_absent

In `ft_absent`, the number of MPs who were absent for each ballot is stored as `numeric` value of the type `double`. Since the record keeping of Folketinget is inconsistent regarding the coding of ballot results, values for this variable are calculated by substracting `ft_for`, `ft_against` and `ft_abstention` from `179`, the total number of MPs in Folketinget, using [`clean_ballot_results()`](../src/targets/clean_ballot_results.R).

The maximum value stored in `ft_absent` is `89` and the minimum value stored in `ft_absent` is `0`. As the total number of MPs in Folketinget is 179, the value of `ft_absent` cannot be greater than `179`.

```r
head(ballot_results_ft$ft_absent)
```

```
## [1] 84 84 84 84 87 86
```

### ballot_results_ft$ft_process_id

All legislative processes in Folketinget are assigned an ID by [Folketingets åbne data service (ODA)](https://www.ft.dk/dokumenter/aabne_data). Each process ID is thus a unique identifier for one process relating to legislation in Folketinget. All IDs are stored as values of the type `integer` as `factor` variable.

This variable corresponds to the [`sagstrinid`](#ballot_info_rawsagstrinid) variable and the `Sagstrin` resource in [the Folketing online database](https://oda.ft.dk).

This variable is eliminated when joining `ballot_results_ft` and `northatlantic_votes` to [`northatlantic_ft`](#northatlantic_ft).

```r
head(ballot_results_ft$ft_process_id)
```

```
## [1] 210645 210647 210665 210678 208578 210739
## 7024 Levels: 100011 100025 100046 100061 100122 100140 100154 1002 ... 99960
```

### ballot_results_ft$ballot_nr

In addition to the [`ballot_id`](#ballot_results_ftballot_id), all ballot procedures in Folketinget are also assigned a number by [Folketingets åbne data service (ODA)](https://www.ft.dk/dokumenter/aabne_data). Each ballot number is thus another identifier for one ballot in Folketinget. All ballot numbers are stored as values of the type `integer` as `factor` variable.

This variable corresponds to the [`ballot_info_raw$nummer`](#ballot_info_rawnummer) variable in the `Afstemning` resource in [the Folketing online database](https://oda.ft.dk). Take care not to confuse `ballot_nr` with [`ballot_id`](#ballot_results_ftballot_id).

```r
head(ballot_results_ft$ballot_nr)
```

```
## [1] 266 267 268 269 270 271
## 745 Levels: 1 10 100 101 102 103 104 105 106 107 108 109 11 110 111 112 ... 99
```

### ballot_results_ft$ballot_type_id

All ballot procedures in Folketinget are categorised using numeric values that correspond to the type of ballot. All Ballot Type IDs are stored as values of the type `integer` as `factor` variable.

| ID  | Type                   | English                         |      n |
| :-- | :--------------------- | :------------------------------ | -----: |
| 1   | Endelig vedtagelse     | Final Adoption                  | `5356` |
| 2   | Udvalgsindstilling     | Committee Recommendation Report |   `14` |
| 3   | Forslag til vedtagelse | Proposed Adoption               |  `859` |
| 4   | Ændringsforslag        | Amendment                       | `3240` |

This variable corresponds to `typeid` variable in [`ballot_info_raw`](#ballot_info_rawtypeid) and the `type` variable in the `Afstemningstype` resource in [the Folketing online database](https://oda.ft.dk).

```r
head(ballot_results_ft$ballot_type_id)
```

```
## [1] 4 1 1 1 1 4
## Levels: 1 2 3 4
```

### ballot_results_ft$comment

If necessary, comments on each ballot are stored as values of the type `character` in Danish language. A Folketing wording standard for `comment` does not seem to exist, so the sentence structures and vocabulary differs a lot between observations. As per January 2024, there are `450` observations with comments (total number of observations: `9469`). Comments on ballot results mostly regard human or technical errors, for example:

| Danish                                                               | English                                                                                 |
| -------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| Ved en fejl er der ikke registreret stemmeafgivning fra X’ plads.    | By mistake, no vote was registeret at X’ seat.                                          |
| Ved en fejl stemte X for/imod/hverken for eller imod forslaget.      | By mistake, X voted for/against/neither for nor against the proposal.                   |
| Ved en fejl har X ikke fået stemt.                                   | By mistake, X could not vote.                                                           |
| Ved en fejl fik X ikke afgivet sin stemme.                           | By mistake, X could not cast a vote.                                                    |
| Ved en fejl er Xs stemme registeret i Ys navn.                       | By mistake, X’ vote was registered as a vote by Y.                                      |
| X stemte ved en fejl fra Y’s plads.                                  | By mistake, X voted from Y’s seat.                                                      |
| 10 i X stemte ved en fejl for/imod/hverken for eller imod forslaget. | By mistake, 10 MPs from party X voted for/against/neither for nor against the proposal. |
| Ved en fejl er der registreret en stemme på X.                       | By mistake, a vote by X was recorded.                                                   |
| X undlod ved en fejl at stemme.                                      | By mistake, X did not cast a vote.                                                      |
| Omafstemning                                                         | Voting Repeated                                                                         |

```r
head(ballot_results_ft$comment)
```

```
## [1] NA
## [2] NA
## [3] NA
## [4] NA
## [5] NA
## [6] "På grund af en fejl er Jens Joels (S) og Lars Christian Lilleholts (V) stemmer registreret som værende for forslaget. De stemte imod."
```

### ballot_results_ft$ballot_result_string

In `ballot_result_string`, ballot results are stored as values of the type `character` in Danish language. The variable indicates whether the proposal was adopted or not; how many votes were in favor resp. against or abstentions, and from which political parties these votes came. A Folketing wording standard for `ballot_result_string` does not seem to exist, so the sentence structures and vocabulary differs a lot between observations.

As per January 2024, there are `6581` observations with result character strings (total number of observations: `9469`). For the observations where `ballot_result_string` is not `NA`, the values are used to calculate [`ft_for`](#ballot_results_ftft_for), [`ft_against`](#ballot_results_ftft_against) and [`ft_abstention`](#ballot_results_ftft_abstention). Information on absent MPs is not provided in `ballot_result_string` but [can be inferred from the other values](#ballot_results_ftft_absent).

```r
str(ballot_results_ft$ballot_result_string)
```

```
##  chr [1:9469] "Forslaget blev forkastet. For stemte 3 (NB, Simon Emil Ammitzbøll-Bille (UFG)), imod stemte 92 (S, V, DF, RV, S"| __truncated__ ...
```

---

## ballot_info_raw

`ballot_info_raw` is provided as `csv` file in [`../data/raw/`](../data/raw). It contains the downloaded data on voting records before any preprocessing. The [processed data](#ballot_results_ft) is available as `rds` file in [`../data/processed`](../data/processed). As per January 2024, `ballot_info_raw.csv` contains 9469 observations of 9 variables.

```r
head(ballot_info_raw)
```

```
##   id nummer
## 1  1    411
## 2  2    412
## 3  3      1
## 4  4      7
## 5  5    412
## 6  6    410
##                                                                                                                                                  konklusion
## 1   Vedtaget\n\n108 stemmer for forslaget (V, S, DF, RV, SF, EL, LA, KF, UFG)\n\n0 stemmer imod forslaget\n\n0 stemmer hverken for eller imod forslaget\n\n
## 2       Vedtaget\n\n98 stemmer for forslaget (V, S, DF, RV, SF, EL)\n\n10 stemmer imod forslaget (LA, KF)\n\n0 stemmer hverken for eller imod forslaget\n\n
## 3       Vedtaget\n\n59 stemmer for forslaget (S, RV, SF, EL)\n\n54 stemmer imod forslaget (V, DF, LA, KF)\n\n0 stemmer hverken for eller imod forslaget\n\n
## 4     Vedtaget\n\n72 stemmer for forslaget (S, DF, RV, SF, EL)\n\n10 stemmer imod forslaget (LA, KF)\n\n26 stemmer hverken for eller imod forslaget (V)\n\n
## 5       Vedtaget\n\n98 stemmer for forslaget (V, S, DF, RV, SF, EL)\n\n10 stemmer imod forslaget (LA, KF)\n\n0 stemmer hverken for eller imod forslaget\n\n
## 6 \nVedtaget\n\n104 stemmer for forslaget (V, S, DF, RV, SF, EL, LA, KF, UFG)\n\n0 stemmer imod forslaget\n\n0 stemmer hverken for eller imod forslaget\n\n
##   vedtaget kommentar mødeid typeid sagstrinid         opdateringsdato
## 1     TRUE      <NA>     17      2         NA 2014-09-09T09:05:59.653
## 2     TRUE      <NA>     18      1       4849 2014-09-09T09:25:05.717
## 3     TRUE               41      3      17351  2018-01-24T16:46:33.99
## 4     TRUE              156      1      18370  2018-01-25T10:25:25.64
## 5     TRUE               18      1       4849  2017-08-10T12:57:52.27
## 6     TRUE               15      1      16581 2017-08-10T12:57:52.257
```

Descriptions of all variables in `ballot_info_raw` are provided in the following sections.

### ballot_info_raw$id

See [ballot_result_ft$ballot_id](#ballot_results_ftballot_id). Take care not to confuse `id` with [`nummer`](#ballot_info_rawnummer). In the raw data, `id` is stored as `integer` value.

```r
head(ballot_info_raw$id)
```

```
## [1] 1 2 3 4 5 6
```

### ballot_info_raw$nummer

See [ballot_results_ft$ballot_nr](#ballot_results_ftballot_nr). Take care not to confuse `nummer` with [`id`](#ballot_info_rawid). In the raw data, `nummer` is stored as `integer` value.

```r
head(ballot_info_raw$nummer)
```

```
## [1] 411 412   1   7 412 410
```

### ballot_info_raw$konklusion

See [ballot_results_ft$ballot_result_string](#ballot_results_ftballot_result_string). In the raw data, `konklusion` is stored as `character` value.

```r
head(ballot_info_raw$konklusion)
```

```
## [1] "Vedtaget\n\n108 stemmer for forslaget (V, S, DF, RV, SF, EL, LA, KF, UFG)\n\n0 stemmer imod forslaget\n\n0 stemmer hverken for eller imod forslaget\n\n"
## [2] "Vedtaget\n\n98 stemmer for forslaget (V, S, DF, RV, SF, EL)\n\n10 stemmer imod forslaget (LA, KF)\n\n0 stemmer hverken for eller imod forslaget\n\n"
## [3] "Vedtaget\n\n59 stemmer for forslaget (S, RV, SF, EL)\n\n54 stemmer imod forslaget (V, DF, LA, KF)\n\n0 stemmer hverken for eller imod forslaget\n\n"
## [4] "Vedtaget\n\n72 stemmer for forslaget (S, DF, RV, SF, EL)\n\n10 stemmer imod forslaget (LA, KF)\n\n26 stemmer hverken for eller imod forslaget (V)\n\n"
## [5] "Vedtaget\n\n98 stemmer for forslaget (V, S, DF, RV, SF, EL)\n\n10 stemmer imod forslaget (LA, KF)\n\n0 stemmer hverken for eller imod forslaget\n\n"
## [6] "\nVedtaget\n\n104 stemmer for forslaget (V, S, DF, RV, SF, EL, LA, KF, UFG)\n\n0 stemmer imod forslaget\n\n0 stemmer hverken for eller imod forslaget\n\n"
```

### ballot_info_raw$vedtaget

See [ballot_results_ft$ballot_pass](#ballot_results_ftballot_pass). In the raw data, `vedtaget` is stored as `logical` value.

```r
head(ballot_info_raw$vedtaget)
```

```
## [1] TRUE TRUE TRUE TRUE TRUE TRUE
```

### ballot_info_raw$kommentar

See [ballot_results_ft$comment](#ballot_results_ftcomment). In the raw data, `kommentar` is stored as `character` value.

```r
head(ballot_info_raw$kommentar)
```

```
## [1] NA NA "" "" "" ""
```

### ballot_info_raw$mødeid

See [ballot_results_ft$meeting_id](#ballot_results_ftmeeting_id). In the raw data, `mødeid` is stored as `integer` value.

```r
head(ballot_info_raw$mødeid)
```

```
## [1]  17  18  41 156  18  15
```

### ballot_info_raw$typeid

See [ballot_results_ft$ballot_type_id](#ballot_results_ftballot_type_id). In the raw data, `typeid` is stored as `integer` value.

```r
head(ballot_info_raw$typeid)
```

```
## [1] 2 1 3 1 1 1
```

### ballot_info_raw$sagstrinid

See [ballot_results_ft$ft_process_id](#ballot_results_ftft_process_id). In the raw data, `sagstrinid` is stored as `integer` value.

```r
head(ballot_info_raw$sagstrinid)
```

```
## [1]    NA  4849 17351 18370  4849 16581
```

### ballot_info_raw$opdateringsdato

For all records kept in [the Folketing online database](https://oda.ft.dk), the time stamp of its last update is stored in `opdateringsdato`. All dates are stored as values of the type `character`. The time stamps are formatted as `%Y-%m-%dT%T`, with some values even at split second level.

This variable is eliminated from [`ballot_results_ft`](#ballot_results_ft) as a result of data processing.

```r
head(ballot_info_raw$opdateringsdato)
```

```
## [1] "2014-09-09T09:05:59.653" "2014-09-09T09:25:05.717"
## [3] "2018-01-24T16:46:33.99"  "2018-01-25T10:25:25.64"
## [5] "2017-08-10T12:57:52.27"  "2017-08-10T12:57:52.257"
```

---

## northatlantic_ft

`northatlantic_ft` is the resulting product of the [targets pipeline](../_targets.R) and is provided as both `rds` file in [`../data/processed`](../data/processed/) and `csv` file in [`../data/processed/csv`](../data/processed/csv). It contains data on voting records of the MPs specified in [`MP_names`](#mp_names), created by processing and joining [`ballot_results_ft`](#ballot_results_ft) and [`northatlantic_votes`](#northatlantic_votes). As per January 2024, `northatlantic_ft` contains 36876 observations of 13 variables.

```r
str(northatlantic_ft)
```

```
## 'data.frame':    36876 obs. of  13 variables:
##  $ ballot_id           : Factor w/ 9469 levels "1","10","100",..: 1 1109 2011 2022 2033 2044 2054 2065 2074 2085 ...
##  $ MP_id               : Factor w/ 20 levels "12283","13","14000",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ vote_type_id        : Factor w/ 4 levels "1","2","3","4": 3 3 3 3 3 3 3 3 3 3 ...
##  $ vote_id             : Factor w/ 36876 levels "1000151","1000154",..: 17242 24913 2940 2984 3028 3072 3116 3160 3204 3248 ...
##  $ ballot_pass         : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
##  $ ft_for              : num  108 98 91 92 58 98 93 54 59 105 ...
##  $ ft_against          : num  0 10 13 13 45 8 13 51 32 0 ...
##  $ ft_abstention       : num  0 0 0 0 0 0 0 0 13 0 ...
##  $ ft_absent           : num  71 71 75 74 76 73 73 74 75 74 ...
##  $ ballot_date         : Date, format: "2014-09-09" "2014-09-09" ...
##  $ ballot_type_id      : Factor w/ 4 levels "1","2","3","4": 2 1 3 1 1 1 1 1 1 1 ...
##  $ comment             : chr  NA NA NA NA ...
##  $ ballot_result_string: chr  "Vedtaget\n\n108 stemmer for forslaget (V, S, DF, RV, SF, EL, LA, KF, UFG)\n\n0 stemmer imod forslaget\n\n0 stem"| __truncated__ "Vedtaget\n\n98 stemmer for forslaget (V, S, DF, RV, SF, EL)\n\n10 stemmer imod forslaget (LA, KF)\n\n0 stemmer "| __truncated__ "Vedtaget\n\n91 stemmer for forslaget (V, S, RV, SF, EL, LA, KF, UFG)\n\n13 stemmer imod forslaget (DF)\n\n0 ste"| __truncated__ "Vedtaget\n\n92 stemmer for forslaget (V, S, RV, SF, EL, LA, KF, UFG)\n\n13 stemmer imod forslaget (DF)\n\n0 ste"| __truncated__ ...
```

Descriptions of all variables in `northatlantic_ft` are provided in the following sections.

### northatlantic_ft$ballot_id

`ballot_id` is created by using [`join_results()`](../src/targets/join_results.R) on `northatlantic_votes` and `ballot_results_ft`. See [`northatlantic_votes$ballot_id`](#northatlantic_votesballot_id).

```r
str(northatlantic_ft$ballot_id)
```

```
##  Factor w/ 9469 levels "1","10","100",..: 1 1109 2011 2022 2033 2044 2054 2065 2074 2085 ...
```

### northatlantic_ft$MP_id

`MP_id` is created by using [`join_results()`](../src/targets/join_results.R) on `northatlantic_votes` and `ballot_results_ft`. See [`northatlantic_votes$MP_id`](#northatlantic_votesmp_id).

```r
str(northatlantic_ft$MP_id)
```

```
##  Factor w/ 20 levels "12283","13","14000",..: 2 2 2 2 2 2 2 2 2 2 ...
```

### northatlantic_ft$vote_type_id

`northatlantic_ft` is a result of [`join_results()`](../src/targets/join_results.R) in which `vote_type_id` is joined from `northatlantic_votes$vote_type_id`. See [`northatlantic_votes$vote_type_id`](#northatlantic_votesvote_type_id).

```r
str(northatlantic_ft$vote_type_id)
```

```
##  Factor w/ 4 levels "1","2","3","4": 3 3 3 3 3 3 3 3 3 3 ...
```

### northatlantic_ft$ballot_pass

See [`ballot_results_ft$ballot_pass`](#ballot_results_ftballot_pass).

```r
str(northatlantic_ft$ballot_pass)
```

```
##  logi [1:36876] TRUE TRUE TRUE TRUE TRUE TRUE ...
```

### northatlantic_ft$ft_for

See [`ballot_results_ft$ft_for`](#ballot_results_ftft_for).

```r
str(northatlantic_ft$ft_for)
```

```
##  num [1:36876] 108 98 91 92 58 98 93 54 59 105 ...
```

### northatlantic_ft$ft_against

See [`ballot_results_ft$ft_against`](#ballot_results_ftft_against).

```r
str(northatlantic_ft$ft_against)
```

```
##  num [1:36876] 0 10 13 13 45 8 13 51 32 0 ...
```

### northatlantic_ft$ft_abstention

See [`ballot_results_ft$ft_abstention`](#ballot_results_ftft_abstention).

```r
str(northatlantic_ft$ft_abstention)
```

```
##  num [1:36876] 0 0 0 0 0 0 0 0 13 0 ...
```

### northatlantic_ft$ft_absent

See [`ballot_results_ft$ft_absent`](#ballot_results_ftft_absent).

```r
str(northatlantic_ft$ft_absent)
```

```
##  num [1:36876] 71 71 75 74 76 73 73 74 75 74 ...
```

### northatlantic_ft$ballot_date

See [`ballot_results_ft$ballot_date`](#ballot_results_ftballot_date).

```r
str(northatlantic_ft$ballot_date)
```

```
##  Date[1:36876], format: "2014-09-09" "2014-09-09" "2014-01-23" "2014-01-23" "2014-01-23" ...
```

### northatlantic_ft$ballot_type_id

See [`ballot_results_ft$ballot_type_id`](#ballot_results_ftballot_type_id).

```r
str(northatlantic_ft$ballot_type_id)
```

```
##  Factor w/ 4 levels "1","2","3","4": 2 1 3 1 1 1 1 1 1 1 ...
```

### northatlantic_ft$comment

See [`ballot_results_ft$comment`](#ballot_results_ftcomment).

```r
str(northatlantic_ft$comment)
```

```
##  chr [1:36876] NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA ...
```

### northatlantic_ft$ballot_result_string

See [`ballot_results_ft$ballot_result_string`](#ballot_results_ftballot_result_string).

```r
str(northatlantic_ft$ballot_result_string)
```

```
##  chr [1:36876] "Vedtaget\n\n108 stemmer for forslaget (V, S, DF, RV, SF, EL, LA, KF, UFG)\n\n0 stemmer imod forslaget\n\n0 stem"| __truncated__ ...
```
