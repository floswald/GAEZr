
# GAEZr

<!-- badges: start -->


[![DOI](https://zenodo.org/badge/513163085.svg)](https://zenodo.org/badge/latestdoi/513163085)

[![DOCS](https://img.shields.io/badge/docs-Documentation-blue)](floswald.github.io/gaezr/)

<!-- badges: end -->

The goal of GAEZr is to facilitate downloading and processing of [GAEZ v4](https://gaez.fao.org/) data in R. The main functionality is to download raster data via the [`gaez_download()`](reference/gaez_download.html) function from this [GAEZ web viewer](https://gaez-data-portal-hqfao.hub.arcgis.com/pages/data-viewer):

![](man/figures/GAEZ-viewer.png "GAEZ v4 Data Viewer")


## Installation

You can install the development version of GAEZr like so:

``` r
devtools::install_github(repo = "floswald/GAEZr")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(GAEZr)
gaez_download_yield_allcrops()  # will download all scenarios and all crops
```

## Other Packages

* `https://gaez.fao.org/pages/pyaez`
