#' Load all data for the provided indicator.
#'
#' @param indicator A valid WHO indicator. Check show_GHO_indicators() for options.
#' @return A data frame containing all data of the WHO indicator.
#' @examples
#' read_GHO_data("WHOSIS_000001")
read_GHO_data <- function(indicator) {
  # Load indicators to verify that user provided indicator does exist
  indicators <- show_GHO_indicators()
  if (!(indicator %in% indicators$IndicatorCode)) {
    stop("Provided indicator does not exist in the WHO database.")
  }

  #TODO allow for filtering using ODATA API
  data <- download_ind(indicator)

  return(data)
}


#' Load table with all available indicators for the GHO API.
#'
#' In the background we load https://ghoapi.azureedge.net/api/Indicator. This
#' is a JSON file with all indicators which are available in the WHO database.
#'
#' @return A data frame with all available indicators.
show_GHO_indicators <- function() {
  data <- download_ind("Indicator")

  return(data)
}
