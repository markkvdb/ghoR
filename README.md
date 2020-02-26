
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ghoR

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/markkvdb/ghoR.svg?branch=master)](https://travis-ci.org/markkvdb/ghoR)
[![Codecov test
coverage](https://codecov.io/gh/markkvdb/ghoR/branch/master/graph/badge.svg)](https://codecov.io/gh/markkvdb/ghoR?branch=master)
<!-- badges: end -->

The ghoR package can be used to conventiently load data from the GHO
portal of the WHO. The GHO database contains over 20,000 *indicators*
which represent a statistic on a country level.

## Installation

You can install the released version of ghoR from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("ghoR")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("markkvdb/ghoR")
```

## Example

If you are not sure yet which indicator you would like to explore you
can discover all indicators by loading it into a dataframe. To prevent
downloading the dataset every time you request a dataset, the dataset is
saved in `~/.ghoR/`. This file is only updated if the WHO website shows
that the dataset is last updated after downloading our local version of
the dataset.

``` r
# First load the library and kable to present table
library(ghoR)
set.seed(420)

# Get a table of all indicators with the code and description.
indicators <- show_GHO_indicators()
indicators_sample <- dplyr::sample_n(indicators, 10)

knitr::kable(indicators_sample)
```

| IndicatorCode         | IndicatorName                                                                                                                                             | Language |
| :-------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------- | :------- |
| WHS7\_108             | Per capita government expenditure on health (PPP int. $)                                                                                                  | EN       |
| CC\_5                 | Climate change attributable deaths (’000) in children under 5 years                                                                                       | EN       |
| EMFLIMITELECTRIC      | Electric field (kV/m)                                                                                                                                     | EN       |
| OCC\_13               | Occupational noise attributable DALYs (’000)                                                                                                              | EN       |
| TOTENV\_11            | Deaths attributable to the environment in children under 5 years (%)                                                                                      | EN       |
| GDO\_q8x3\_5          | Accessibility of palliative and end-of-life care services in community for dementia \[Capital/capital and main cities/capital, main cities, rural areas\] | EN       |
| TB\_new\_clindx       | New or unknown treatment history cases: Pulmonary, clinically diagnosed                                                                                   | EN       |
| HIV\_0000000020       | Estimated percentage of pregnant women living with HIV who received antiretrovirals for preventing mother-to-child transmission                           | EN       |
| IR\_CARBAMATE\_EXTENT | Percentage of sites for which carbamate resistance was reported                                                                                           | EN       |
| SHS\_1                | Percentage of children under 15 years exposed to second-hand smoke                                                                                        | EN       |

As an example, we will look at the remaining life expectancy from age
\(x\) for all available countries, years, sexes and ages. We can load
this data using

``` r
ex_data <- read_GHO_data("LIFE_0000000035")

knitr::kable(head(ex_data, 10))
```

|       Id | IndicatorCode    | SpatialDimType | SpatialDim | TimeDimType | TimeDim | Dim1Type | Dim1 | Dim2Type | Dim2     | Dim3Type | Dim3 | DataSourceDimType | DataSourceDim | Value | NumericValue | Low | High | Comments | Date                          |
| -------: | :--------------- | :------------- | :--------- | :---------- | ------: | :------- | :--- | :------- | :------- | :------- | :--- | :---------------- | :------------ | :---- | -----------: | :-- | :--- | :------- | :---------------------------- |
| 15578369 | LIFE\_0000000035 | COUNTRY        | RWA        | YEAR        |    2000 | SEX      | BTSX | AGEGROUP | AGELT1   | NA       | NA   | NA                | NA            | 45.7  |     45.70058 | NA  | NA   | NA       | 2017-03-31T08:39:36.323+02:00 |
| 15578390 | LIFE\_0000000035 | COUNTRY        | RWA        | YEAR        |    2000 | SEX      | BTSX | AGEGROUP | AGE1-4   | NA       | NA   | NA                | NA            | 50.3  |     50.25219 | NA  | NA   | NA       | 2017-03-31T08:39:37.38+02:00  |
| 15578411 | LIFE\_0000000035 | COUNTRY        | RWA        | YEAR        |    2000 | SEX      | BTSX | AGEGROUP | AGE5-9   | NA       | NA   | NA                | NA            | 50.6  |     50.56797 | NA  | NA   | NA       | 2017-03-31T08:39:38.317+02:00 |
| 15578432 | LIFE\_0000000035 | COUNTRY        | RWA        | YEAR        |    2000 | SEX      | BTSX | AGEGROUP | AGE10-14 | NA       | NA   | NA                | NA            | 47.4  |     47.35501 | NA  | NA   | NA       | 2017-03-31T08:39:39.123+02:00 |
| 15578453 | LIFE\_0000000035 | COUNTRY        | RWA        | YEAR        |    2000 | SEX      | BTSX | AGEGROUP | AGE15-19 | NA       | NA   | NA                | NA            | 43.3  |     43.25390 | NA  | NA   | NA       | 2017-03-31T08:39:40.14+02:00  |
| 15578474 | LIFE\_0000000035 | COUNTRY        | RWA        | YEAR        |    2000 | SEX      | BTSX | AGEGROUP | AGE20-24 | NA       | NA   | NA                | NA            | 39.2  |     39.19952 | NA  | NA   | NA       | 2017-03-31T08:39:41.17+02:00  |
| 15578495 | LIFE\_0000000035 | COUNTRY        | RWA        | YEAR        |    2000 | SEX      | BTSX | AGEGROUP | AGE25-29 | NA       | NA   | NA                | NA            | 35.4  |     35.41076 | NA  | NA   | NA       | 2017-03-31T08:39:42.293+02:00 |
| 15578516 | LIFE\_0000000035 | COUNTRY        | RWA        | YEAR        |    2000 | SEX      | BTSX | AGEGROUP | AGE30-34 | NA       | NA   | NA                | NA            | 32    |     31.97939 | NA  | NA   | NA       | 2017-03-31T08:39:43.363+02:00 |
| 15578537 | LIFE\_0000000035 | COUNTRY        | RWA        | YEAR        |    2000 | SEX      | BTSX | AGEGROUP | AGE35-39 | NA       | NA   | NA                | NA            | 28.9  |     28.89335 | NA  | NA   | NA       | 2017-03-31T08:39:44.717+02:00 |
| 15578558 | LIFE\_0000000035 | COUNTRY        | RWA        | YEAR        |    2000 | SEX      | BTSX | AGEGROUP | AGE40-44 | NA       | NA   | NA                | NA            | 26    |     25.98571 | NA  | NA   | NA       | 2017-03-31T08:39:45.543+02:00 |

## Tidying dataset

Datasets downloaded from the WHO website do not follow the tidy
philosophy. For the spatial, time and other dimensions, each dimension
has a column for the unit of the dimension and one for the value. Most
users prefer having their datasets ready for analysis. The `ghoR`
package provides a function to transform the dataset as

``` r
tidy_data <- tidy_data(ex_data)

knitr::kable(head(tidy_data, 10))
```

|       Id | IndicatorCode    | Value | NumericValue | Low | High | Comments | Date                          | COUNTRY | REGION | YEAR | SEX  | AGEGROUP |
| -------: | :--------------- | :---- | -----------: | :-- | :--- | :------- | :---------------------------- | :------ | :----- | ---: | :--- | :------- |
| 15578369 | LIFE\_0000000035 | 45.7  |     45.70058 | NA  | NA   | NA       | 2017-03-31T08:39:36.323+02:00 | RWA     | NA     | 2000 | BTSX | AGELT1   |
| 15578390 | LIFE\_0000000035 | 50.3  |     50.25219 | NA  | NA   | NA       | 2017-03-31T08:39:37.38+02:00  | RWA     | NA     | 2000 | BTSX | AGE1-4   |
| 15578411 | LIFE\_0000000035 | 50.6  |     50.56797 | NA  | NA   | NA       | 2017-03-31T08:39:38.317+02:00 | RWA     | NA     | 2000 | BTSX | AGE5-9   |
| 15578432 | LIFE\_0000000035 | 47.4  |     47.35501 | NA  | NA   | NA       | 2017-03-31T08:39:39.123+02:00 | RWA     | NA     | 2000 | BTSX | AGE10-14 |
| 15578453 | LIFE\_0000000035 | 43.3  |     43.25390 | NA  | NA   | NA       | 2017-03-31T08:39:40.14+02:00  | RWA     | NA     | 2000 | BTSX | AGE15-19 |
| 15578474 | LIFE\_0000000035 | 39.2  |     39.19952 | NA  | NA   | NA       | 2017-03-31T08:39:41.17+02:00  | RWA     | NA     | 2000 | BTSX | AGE20-24 |
| 15578495 | LIFE\_0000000035 | 35.4  |     35.41076 | NA  | NA   | NA       | 2017-03-31T08:39:42.293+02:00 | RWA     | NA     | 2000 | BTSX | AGE25-29 |
| 15578516 | LIFE\_0000000035 | 32    |     31.97939 | NA  | NA   | NA       | 2017-03-31T08:39:43.363+02:00 | RWA     | NA     | 2000 | BTSX | AGE30-34 |
| 15578537 | LIFE\_0000000035 | 28.9  |     28.89335 | NA  | NA   | NA       | 2017-03-31T08:39:44.717+02:00 | RWA     | NA     | 2000 | BTSX | AGE35-39 |
| 15578558 | LIFE\_0000000035 | 26    |     25.98571 | NA  | NA   | NA       | 2017-03-31T08:39:45.543+02:00 | RWA     | NA     | 2000 | BTSX | AGE40-44 |

## Updating Datasets

To prevent downloading the dataset every time you request a dataset, the
dataset is saved in `~/.ghoR/`. This file is only updated if the WHO
website shows that the last update date is after the last updated date
of the downloaded dataset on the user’s computer.
