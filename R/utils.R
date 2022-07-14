
#' RCP Types
#'
#' @export
#' @examples rcps()
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
#' @export
#' @examples irrigation()
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
#' @export
#' @examples climate_models()
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

#' Gaez Filename Constructor
#'
#' @export
#' @examples gaez_filename("popeye-spinach","yx","L","r","1")
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
#' @export
#' @examples allscenarios()
allscenarios <- function(){
    dplyr::bind_rows(
        tibble::tibble(climate_model = "CRUTS32",
                       rcp = "Hist",
                       time_period = "8110"),
        tidyr::expand_grid(climate_model = climate_models(),
                           rcp = rcps()$code,
                           time_period = "2080s"))
}


# variable names


#' Variable Names for Theme 4 of GAEZ v4
#'
#' This is the *Suitability and Attainable Yield* theme of GAEZ.
#'
#' @export
#' @examples theme4_varnames()
theme4_varnames <- function(){
    tibble::tribble(
        ~variable, ~meaning,
        "yl","Output Density",
        "yc", "Average attainable yield of current cropland",
        "yx", "Average attainable yield of best occurring suitability class in grid cell",
        "sx1", "Share of grid cell assessed as VS or S (range 0 – 10000)",
        "sx2", "Share of VS+S+MS land in grid cell (range 0 – 10000)",
        "sx", "Suitability index range (0 – 10000); all land in grid cell",
        "su", "Suitability index range (0 – 10000); current cropland in grid cell")
}


#' Subtheme Names for Theme 1 of GAEZ v4
#'
#' This are the subthemes of *Land and Water Resources* theme of GAEZ.
#'
#' @export
#' @examples theme1_subs()
theme1_subs <- function(){
    tibble::tribble(
        ~variable, ~meaning,
        "soi1","Soil Resources",
        "soi2","Soil Suitability",
        "aez","Agro Ecological Zones",
        "excl","Exclusion Class")
}



#' Variable Names for Soil Resources
#'
#' This is a subtheme of the *Land and Water Resources* theme of GAEZ. Part of the `soi1` subtheme.
#'
#' @export
#' @examples soil_resources_varnames()
soil_resources_varnames <- function(){
    tibble::tribble(
        ~variable, ~meaning,
        "hwsd_domi_30s","Dominant Soil (30 arc seconds)",
        "hwsd_domi", "Dominant Soil (5 arc minutes)",
        "SQ0_mze_v9aH", "Most limiting soil quality rating factor, high inputs",
        "SQ0_mze_v9aL", "Most limiting soil quality rating factor, low inputs",
        "SQ0_idx_v9aH", "Most limiting soil quality, high inputs",
        "SQ0_idx_v9aL", "Most limiting soil quality, low inputs",
        "SQ1_mze_v9aL", "Nutrient availability, low inputs",
        "SQ2_mze_v9aH", "Nutrient retention capacity, high inputs",
        "SQ3_mze_v9aH", "Rooting conditions, high inputs",
        "SQ3_mze_v9aL", "Rooting conditions, low inputs",
        "SQ7_mze_v9aH", "Workability, high inputs",
        "SQ7_mze_v9aL", "Workability, low inputs")
}

#' Variable Names for Soil Suitability
#'
#' This is a subtheme of the *Land and Water Resources* theme of GAEZ. Part of the `soi2` subtheme.
#'
#' @export
#' @examples soil_suitability_varnames()
soil_suitability_varnames <- function(){
    tibble::tribble(
        ~variable, ~meaning,
        "siHr_sst_mze","Soil and terrain suitability, rain-fed, high inputs",
        "siLr_sst_mze","Soil and terrain suitability, rain-fed, low inputs",
        "siHr_sss_mze","Soil suitability, rain-fed, high inputs",
        "siLr_sss_mze","Soil suitability, rain-fed, low inputs")
}


#' Variable Names for Terrain Resources
#'
#' This is a subtheme of the *Land and Water Resources* theme of GAEZ. Part of the `ter` subtheme.
#'
#' @export
#' @examples terrain_resources_varnames()
terrain_resources_varnames <- function(){
    tibble::tribble(
        ~variable, ~meaning,
        "slpmed05m","Median terrain slope class (5 arc-minute)",
        "slpmed30s","Median terrain slope class (30 arc-seconds)")
}

