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
  parts <- do.call(rbind, lapply(regmatches(url, matches), `[`, c(3L, 4L, 5L, 6L, 7L)))
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


#' Indicator value to local JSON file
#'
#' @param ind An valid indicator of the GHO API.
#' @return
#' @examples
#' ind_to_json("RSUD_30")
ind_to_json <- function(ind) {
  json <- paste0("inst/", ind, ".json")

  return(json)
}

#' Check if indicator data is already downloaded and in "cache"
#'
#' @param ind A valid indicator of the GHO API.
#' @return TRUE if indicator is in cache, FALSE if not.
#' @examples
#' ind_in_cache("RSUD_30")
ind_in_cache <- function(ind) {
  return(file.exists(ind_to_json(ind)))
}


#' Download file of indicator and read it into a data frame
#'
#' @param ind A valid indicator of the GHO API.
#' @return Tibble with data of indicator
#' @examples
#' data <- download_ind("RSUD_30")
download_ind <- function(ind) {
  # Download file if it doesn't exist already
  if (!ind_in_cache(ind)) {
    utils::download.file(url=ind_to_url(ind),
                         destfile=ind_to_json(ind),
                         method="auto")
  }

  # Open json file and read it into tibble
  json <- rjson::fromJSON(file=ind_to_json(ind))[["value"]]

  # Replace NULL values by NA
  json_NA <- lapply(json, null_to_NA_list)
  data <- do.call(rbind,
                  lapply(json_NA, rbind.data.frame, stringsAsFactors=FALSE))

  return(dplyr::as_tibble(data))
}


#' Turn all NULL elements of list to NA.
#'
#' @param list A list object
#' @return A list object with NULL elements replaced by NA
null_to_NA_list <- function(list) {
  list <- lapply(list, function(x) replace(x, is.null(x), NA))

  return(list)
}
