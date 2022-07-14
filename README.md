
# GAEZr

<!-- badges: start -->
<!-- badges: end -->

The goal of GAEZr is to facilitate downloading and processing of [GAEZ v4](https://gaez.fao.org/) data in R. The main functionality is to download raster data via the [`gaez_download()`](reference/gaez_download.html) function from this [GAEZ web viewer](https://gaez-data-portal-hqfao.hub.arcgis.com/pages/data-viewer):

![](man/figures/GAEZ-viewer.png "GAEZ v4 Data Viewer")


## Installation

You can install the development version of GAEZr like so:

``` r
remotes::install_github(repo = "floswald/GAEZr")
```

## Examples

Download wheat potential yields under the 1981-2010 climate.

``` r
library(GAEZr)
gaez_download("whe")
```

Download potential yields for all crops and all scenarios

``` r
gaez_download_yield_allcrops()
```

## Other Packages

* <https://gaez.fao.org/pages/pyaez>
