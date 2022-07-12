
#' RCP Types
#'
rcps <- function() {
    tibble::tribble(
        ~rcp, ~code,
        "RCP8.5", "rcp8p5",
        "RCP6.0", "rcp6p0",
        "RCP4.5", "rcp4p5",
        "RCP2.6", "rcp2p6")
}

#' Irrigation Types
#'
irrigation <- function() {
    tibble::tribble(
    ~irrigation, ~code,
    "Irrigation", "i",
    "Rainfed", "r",
    "Gravity Irrigation", "g",
    "Sprinkler Irrigation", "s")
}

#' Climate Models
#'
climate_models <- function() {
    c(
    "NorESM1-M",
    "MIROC-ESM-CHEM",
    "IPSL-CM5A-LR",
    "HadGEM2-ES",
    "GFDL-ESM2M"## ,
    ## "ENSEMBLE"
    )
}

gaez_filename <- function(crop, variable = "yl", input = "H", irrigation = "r",
                          co2 = "0") {
    paste0(variable, input, irrigation, co2, "_", crop, ".tif")
}


#' Make a tibble of all scenarios
#'
#' a Scenario is defined by three entries:
#' 1. the climate model
#' 2. the RCP definition
#' 3. the time period
#'
#' This function returns all possible scenarios.
allscenarios <- function(){
    dplyr::bind_rows(
        tibble::tibble(climate_model = "CRUTS32",
                       rcp = "Hist",
                       time_period = "8110"),
        tidyr::expand_grid(climate_model = climate_models(),
                           rcp = rcps()$code,
                           time_period = "2080s"))
}

