# Voting Records of Greenlandic and Faroese MPs in Folketinget

This repository contains voting records of Greenlandic and Faroese Members of Parliament (MPs) in Folketing, the Parliament of Denmark. The data in nordatlantisk-ft is openly available to everyone and is intended to support reproducible research.

[![GitHub issues](https://img.shields.io/github/issues/mtwente/nordatlantisk-ft.svg)](https://github.com/mtwente/nordatlantisk-ft/issues) [![GitHub forks](https://img.shields.io/github/forks/mtwente/nordatlantisk-ft.svg)](https://github.com/mtwente/nordatlantisk-ft/network) [![GitHub stars](https://img.shields.io/github/stars/mtwente/nordatlantisk-ft.svg)](https://github.com/mtwente/nordatlantisk-ft/stargazers) [![GitHub license](https://img.shields.io/github/license/mtwente/nordatlantisk-ft.svg)](https://github.com/mtwente/nordatlantisk-ft/blob/main/LICENSE.md) [![Zotero](https://img.shields.io/badge/zotero-nordatlantisk--ft-red?style=flat&logo=zotero&logoColor=white&labelColor=565656&color=bb393c)](https://www.zotero.org/groups/5346749/nordatlantisk-ft)

## Repository Structure

The structure of this repository is based on the [Open Research Data Template](https://github.com/maehr/open-research-data-template) by [@maehr](https://github.com/maehr), follows the [Advanced Structure for Data Analysis](https://the-turing-way.netlify.app/project-design/project-repo/project-repo-advanced.html) of _The Turing Way_ and is organized as follows:

- `analysis/`: scripts and notebooks used to analyze the data
- `assets/`: images, logos, etc. used in the README and other documentation
- `build/`: built files, PDF outputs
- `data/`: data files
- `docs/`: documentation for the data and the repository
- `src/`: source code for the data (e.g., scripts used to collect or process the data)
- `test/`: tests for the data and source code
- `report.md`: a report with basic insights into the data set

Additionally, there is a [Zotero group library](https://www.zotero.org/groups/5346749/nordatlantisk-ft) with a collection of scientific articles and news reports that are of relevance for studying the Northatlantic MPs' work in Folketinget.

## Data Description

This repository contains voting records of Greenlandic and Faroese MPs. Voting records are available online starting October 2004.

For all MPs that were elected in either Greenland or the Faroe Islands since 2004, voting records were retrieved from [Folketingets åbne data service (ODA)](https://www.ft.dk/dokumenter/aabne_data). Because Folketinget seems to have changed their way of record keeping since 2004, the retrieved data had to be processed to consolidate different variables (e.g. extracting ballot results stored as one text string into four numeric variables).

In this repository, the raw data is available as `csv` files, and processed data is available as `rds` and `csv` files including metadata. Also included is the workflow to replicate and update the data set using R.

Descriptions of all variables are provided in the [codebook](./docs/codebook.md). Take a first glance at the dataset [in report.md](report.md).

### Installation

Use the [renv package](https://rstudio.github.io/renv/index.html) to install all dependencies and set up a reproducible environment within the R project. To see which packages are loaded with renv for the workflow before installing them to the project library, run `renv::dependencies()`.

```r
renv::restore()
```

If you are running a recent Mac OS, you will have to [install a Fortran compiler manually](https://mac.r-project.org/tools/) for compiling the packages before running `renv::restore()`.

### Build

This project uses the [targets package](https://books.ropensci.org/targets/) for managing the workflow of building and updating the data set.

```r
targets::tar_make()
```

Running `tar_make()` will execute the workflow as defined in [`_targets.R`](./_targets.R), skipping files ('targets') that have not changed since the last build process.

The targets pipeline is set to check for new voting records **every twelve weeks only**. To force running the scripts with the most recent data available, remove the `cue` arguments from the targets `ballot_info` and `raw_voting_records` in `_targets.R`.

You can use the scripts to assemble data sets with voting records of other members of Folketinget as well. To download voting records for other MPs, look up their ODA IDs at [oda.ft.dk](https://oda.ft.dk), add the IDs to the column `MP_names$MP_id` in the file available at [`./data/processed/csv/MP_names.csv`](./data/processed/csv/MP_names.csv) and then run `targets::tar_make()`.

## Use

This data is openly available to everyone and can be used for any research or educational purpose. If you use this data in your research, please cite as specified in [CITATION.cff](CITATION.cff).

## Support

This project is maintained by [@mtwente](https://github.com/mtwente). Please understand that we can't provide individual support via email. We also believe that help is much more valuable when it's shared publicly, so more people can benefit from it.

| Type                                   | Platforms                                                                     |
| -------------------------------------- | ----------------------------------------------------------------------------- |
| 🚨 **Bug Reports**                     | [GitHub Issue Tracker](https://github.com/mtwente/nordatlantisk-ft/issues)    |
| 📊 **Report bad data**                 | [GitHub Issue Tracker](https://github.com/mtwente/nordatlantisk-ft/issues)    |
| 📚 **Docs Issue**                      | [GitHub Issue Tracker](https://github.com/mtwente/nordatlantisk-ft/issues)    |
| 🎁 **Feature Requests**                | [GitHub Issue Tracker](https://github.com/mtwente/nordatlantisk-ft/issues)    |
| 🛡 **Report a security vulnerability** | See [SECURITY.md](SECURITY.md)                                                |
| 💬 **General Questions**               | [GitHub Discussions](https://github.com/mtwente/nordatlantisk-ft/discussions) |

## Roadmap

- implement function to automatically match MP names with IDs from [oda.ft.dk](https://oda.ft.dk), perhaps using [Wikidata](https://www.wikidata.org/wiki/Property:P10207)
- implement [gittargets](https://github.com/ropensci/gittargets)
- implement [frictionless-r](https://github.com/frictionlessdata/frictionless-r)
- implement tests
- in addition to the [Zotero Group](https://www.zotero.org/groups/5346749/nordatlantisk-ft), provide bibliography for scientific literature on Northatlantic MPs as BibTeX file.
- add DOI to README and CITATION.cff

## Contributing

All contributions to this repository are welcome! If you find errors or problems with the data, or if you want to add new data or features, please open an issue or pull request. Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## Versioning

We use [SemVer](http://semver.org/) for versioning. The available versions are listed in the [tags on this repository](https://github.com/mtwente/nordatlantisk-ft/tags).

## Authors and acknowledgment

- **Moritz Twente** - _Initial work_ - [mtwente](https://github.com/mtwente)

See also the list of [contributors](https://github.com/mtwente/nordatlantisk-ft/graphs/contributors) who contributed to this project.

Voting records and ballot results were retrieved from [Folketinget's open data service](https://oda.ft.dk/) under [Folketinget's terms of service](https://www.ft.dk/dokumenter/aabne_data).

## License

The data in this repository is released under the Creative Commons Attribution 4.0 International (CC BY 4.0) License - see the [LICENSE.md](LICENSE.md) file for details. By using this data, you agree to give appropriate credit to the original author(s) and to indicate if any modifications have been made.
