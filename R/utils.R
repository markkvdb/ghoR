#' Separate parts of the API url for further analysis
#'
#' @param url A GHO API call.
#' @return A matrix with the protocol, host, api, indicator and possible filter.
#' @examples
#' separate_url("https://ghoapi.azureedge.net/api/Indicator?")
separate_url <- function(url) {
  # Use regex to separate url in parts
  matches <- regexec("^(([^:]+)://)?([^:/]+)(/api/)([^?]*)(\\?.*)", url)

  # Save parts in
  parts <- do.call(rbind, lapply(regmatches(x, matches), `[`, c(3L, 4L, 5L, 6L, 7L)))
  colnames(parts) <- c("protocol", "host", "api", "indicator", "filter")

  return(parts)
}


#' Indicator value to valid API url
#'
#' @param ind An valid indicator of the GHO API.
#' @return A valid GHO API url in string format.
#' @examples
#' ind_to_url("RSUD_30")
ind_to_url <- function(ind) {
  url <- paste0("https://ghoapi.azureedge.net/api/", ind)

  return(url)
}


#' Check if indicator data is already downloaded and in "cache"
#'
#' @param ind A valid indicator of the GHO API
