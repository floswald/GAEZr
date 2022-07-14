

gaez_url <- function(){"https://s3.eu-west-1.amazonaws.com/data.gaezdev.aws.fao.org/"}


#' GAEZ v4 Crop Yield Downloader
#'
#' GAEZ v4 data is available via an online Image Service server. Querying a certain
#' URL, properly composed, serves a raster image to the user for download. The corresponding base URLs are available in the first table of the [Data Access page of GAEZ](https://gaez-data-portal-hqfao.hub.arcgis.com/pages/data-access-download).
#'
#' This function composes a URL string and sends the query to the server. For example, one can download GAEZ data for a certain [GAEZ theme](https://gaez.fao.org/pages/modules), a given crop, input and irrigation settings for a certain scenario into a corresponding folder on disk. _This function is helpful for Crop Yield Data._
#' The simplest way to compose an URL is to use the [GAEZ data viewer](https://gaez-data-portal-hqfao.hub.arcgis.com/pages/data-viewer), following the steps below. The viewer looks like this:
#' ![](GAEZ-viewer.png "GAEZ v4 Data Viewer")
#' 1. choose appropriate theme on top
#' 2. Choose a variable (if known-else leave blank for default choice): not all variables are available in all combinations
#' 3. Choose Time period (or leave blank)
#' 4. Choose Climate Model. available via [climate_models()]
#' 5. Choose RCP scenario (only if making extrapolation to the future): available via [rcps()]
#' 6. Choose a crop. via `data(crops)`
#' 7. Choose Water Supply. codes in [irrigation()]
#' 8. Choose an input level (high or low)
#' 9. Choose with or without CO2 fertilizer
#'
#' The image on the right of the dropdown menus is your current raster, which can be downloaded. You will notice that not all data is available in all parts of the world.
#'
#' @section How To Get the URL String:
#' In the data viewer, zoom into a region of interest and click on an arbitrary pixel, as illustrated here:
#' ![](GAEZ-select.png "GAEZ v4 Pixel Selector")
#'
#' In the appearing popup menu, right click on link *download this raster*. It
#' will have a form like
#' `https://s3.eu-west-1.amazonaws.com/data.gaezdev.aws.fao.org/res05/CRUTS32/Hist/6190H/ycHr0_whe.tif`,
#' which composes as follows:
#'
#' * Base url: `https://s3.eu-west-1.amazonaws.com/data.gaezdev.aws.fao.org`
#' * GAEZ theme: `res05`
#' * Climate Model: `CRUTS32`
#' * Climate Scenario: *Hist* for past, one of several _RCP_ scenarios for future.
#' * Time Period: `6190H` stands for 1961 thru 1990 *Historical*
#' * The Variable name: `ycHr0_whe.tif`
#'     * `yc` stands for *Average attainable yield of current cropland*. Other values in Theme 4 are for example `yl` (*Output Density (potential production divided by total grid cell area*)) or `yx` (*Average attainable yield of best occurring suitability class in grid cell*)
#'     * `H` is the choice of input level (High or Low)
#'     * `r` whether rainfed (see [irrigation()])
#'     * `0` whether there is CO2 fertilization.
#'     * `whe` is the crop code from `data(crops)`.
#'
#' Christophe Gouel wrote the core of this function. Florian Oswald rearranged and wrote the supporting documentation.
#'
#' @param cropcode string one `code` from `data(crops)`
#' @param variable string variable name
#' @param input string `"H"` or `"L"`
#' @param irrigation string code from [irrigation()]
#' @param co2 string `""` for CO2 fertilization (the default) or `"0"` without
#' (not available for historical climate)
#' @param scenario vector of string with 3 elements: Climate Model, Climate
#' Scenario, Time period.
#' @param dir path to folder where GAEZ data will be stored. Default `.`
#' @param res string indicating the GAEZ theme (e.g. `"05"` corresponds to
#' [Theme 4, Suitability and Attainable Yield](https://data.apps.fao.org/map/catalog/srv/eng/catalog.search#/metadata/d4ab84c5-4157-47c4-a544-a2e6244e29bb))
#' @examples
#' gaez_download("whe")
#'
#' @export
gaez_download <- function(cropcode, variable = "yl", input = "H",
                                irrigation = "r", co2 = "",
                                scenario = c("CRUTS32", "Hist", "8110"),
                                dir = ".",
                                res = "res05/") {
    if (length(scenario) != 3){
        error("`scenario` is a vector with 3 entries: climate model, RCP, time period")
    }
    filename <- gaez_filename(cropcode,
                              variable = variable,
                              input = input,
                              irrigation = irrigation,
                              co2 = co2)
    url <- paste0(gaez_url(), res,
                  paste0(scenario, collapse = "/"), input, "/", filename)
    logger::log_info("downloading from {url}")


    dest_dir <- file.path(dir,paste(scenario,collapse = .Platform$file.sep))
    dest_file <- file.path(dest_dir,filename)
    dir.create(dest_dir,
               recursive = TRUE,
               showWarnings = FALSE)
    tryCatch(
        download.file(url,
                      destfile = dest_file,
                      quiet = TRUE,
                      mode = "wb"),
        error = function(x) {
            file.remove(dest_file)
            logger::log_error("{filename} not downloaded")
        }
    )
}


#' Batch download All Crops
#'
#' Downloads all crops for [allscenarios()]
#'
#' @export
gaez_download_yield_allcrops <- function(dir = ".",
                                         scenarios = allscenarios(),
                                         var = "yl"){
    data(crops)
    nrow(scenarios) %>%
        seq_len() %>%
        purrr::walk(function(iscen) {
            # Download for all crops and the 2 CO2 fertilization variants
            tidyr::expand_grid(crop = crops[["code"]], co2 = c("", "0")) %>%
                purrr::pwalk(function(crop, co2) {
                    gaez_download(cropcode = crop,
                                  variable = var,
                                        co2 = co2,
                                        scenario = unlist(scenarios[iscen,]),
                                        dir = dir)
                })
        })
}


#' Land and Water Resources Download
#'
#' Same as [gaez_download()] but for the Land and Water Resources Theme.
#'
#' Notice that this vectorizes naturally for a vector of variable names within the same subtheme.
#'
#' @export
#' @examples
#' terrain_vars = terrain_resources_varnames()[["variable"]]
#' length(terrain_vars)
#' gaez_LR_download(subtheme = "ter",variable = terrain_vars)
gaez_LR_download <- function(dir = ".",subtheme = "soi1", variable = "hwsd_domi_30s") {
    filename <- paste0(variable,".tif")

    url <- paste0(gaez_url(), paste0("LR/",subtheme,"/",variable,".tif"))
    logger::log_info("downloading from {url}")

    dest_dir <- file.path(dir,"LR",subtheme)
    dest_file <- file.path(dest_dir,filename)
    dir.create(dest_dir,
               recursive = TRUE,
               showWarnings = FALSE)
    tryCatch(
        download.file(url,
                      destfile = dest_file,
                      quiet = TRUE,
                      mode = "wb"),
        error = function(x) {
            file.remove(dest_file)
            logger::log_error("{filename} not downloaded")
        }
    )
}

