

gaez_url <- function(){"https://s3.eu-west-1.amazonaws.com/data.gaezdev.aws.fao.org/"}


#' Download Attainable Yield Data
#'
#' Downloads GAEZ yield data for a given crop, input and irrigation settings
#' for a certain scenario into a corresponding folder on disk.
#'
#' @param dir path to folder where GAEZ data will be stored. Default `.`
gaez_download_yield <- function(cropcode, variable = "yl", input = "H",
                                irrigation = "r", co2 = "0",
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
        downloader::download(url,
                      destfile = dest_file),
        error = function(x) {
            file.remove(dest_file)
            logger::log_error("{url} not downloaded")
        }
    )
}

gaez_download_yield_allcrops <- function(dir = ".", scenarios = allscenarios()){
    data(crops)
    nrow(scenarios) %>%
        seq_len() %>%
        purrr::walk(function(iscen) {
            # Download for all crops and the 2 CO2 fertilization variants
            tidyr::expand_grid(crop = crops[["code"]], co2 = c("", "0")) %>%
                purrr::pwalk(function(crop, co2) {
                    gaez_download_yield(cropcode = crop,
                                        co2 = co2,
                                        scenario = unlist(scenarios[iscen,]),
                                        dir = dir)
                })
        })
}

# nrow(scen) %>%
#     seq_len() %>%
#     walk(function(iscen) {
#         # Create diretories for the scenario
#         dir.create(here("data", "gaez4",
#                         scen[[iscen, "climate_model"]],
#                         scen[[iscen, "rcp"]],
#                         scen[[iscen, "time_period"]]),
#                    recursive = T,
#                    showWarnings = F)
#         # Download for all crops and the 2 CO2 fertilization variants
#         expand_grid(crop = crops[["code"]], co2 = c("", "0")) %>%
#             pwalk(function(crop, co2) {
#                 download_gaez_yield(crop = crop,
#                                     co2 = co2,
#                                     scenario = unlist(scen[iscen,]),
#                                     dir = here("data", "gaez4"))
#             })
#     })
