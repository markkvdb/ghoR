#' Separate parts of the API url for further analysis
#'
#' @param url A GHO API call.
#' @return A matrix with the protocol, host, api, indicator and possible filter.
separate_url <- function(url) {
  # Use regex to separate url in parts
  matches <- regexec("^(([^:]+)://)?([^:/]+)(/api/)([^?]*)(\\?.*)", url)

  # Save parts in
  parts <- t(sapply(regmatches(url, matches), `[`, c(3L, 4L, 5L, 6L, 7L)))
  colnames(parts) <- c("protocol", "host", "api", "indicator", "filter")

  return(parts)
}


#' Indicator value to valid API url
#'
#' @param ind An valid indicator of the GHO API.
#' @return A valid GHO API url in string format.
ind_to_url <- function(ind) {
  url <- paste0("https://ghoapi.azureedge.net/api/", ind)

  return(url)
}


#' Indicator value to local JSON file
#'
#' @param ind An valid indicator of the GHO API.
#' @return JSON file with data for given indicator
ind_to_json <- function(ind) {
  json <- paste0("~/.ghoR/", ind, ".json")

  return(json)
}

#' Check if indicator data is already downloaded and in "cache"
#'
#' @param ind A valid indicator of the GHO API.
#' @return TRUE if indicator is in cache, FALSE if not.
ind_in_cache <- function(ind) {
  if (!dir.exists("~/.ghoR")) {
    dir.create("~/.ghoR")
  }

  return(file.exists(ind_to_json(ind)))
}


#' Download file of indicator and read it into a data frame
#'
#' @param ind A valid indicator of the GHO API.
#' @return Tibble with data of indicator.
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
  data <- data.table::rbindlist(json_NA)

  return(data)
}


#' Turn all NULL elements of list to NA.
#'
#' @param list A list object
#' @return A list object with NULL elements replaced by NA
null_to_NA_list <- function(list) {
  list <- lapply(list, function(x) replace(x, is.null(x), NA))

  return(list)
}

#' Generate a SHA256 hash file from a downloaded WHO data file
#'
#' @param data A data object
#' @return A character string of length 64 containing the SHA256 string
create_hash_from_data <- function(data) {
  return(digest::digest(data, algo="sha256", serialize=T))

  #Potentially insert the hash with the date of generation, WHO Indicator and other metadata in a centrally accessible online SQL database
  #So that we can check whether a date file has been updated (compared to the cached local version)
}

#' Retrieve the last update date of an indicator from WHO
#'
#' @param ind A valid indicator of the GHO API.
#' @return A Date object containing the last update
ind_to_last_update <- function(ind) {
  #We would like to minimize the download time, so we scrape the empty table and save it as an xml structure
  url_part_1 <- "https://apps.who.int/gho/athena/data/GHO/"
  url_part_2 <- ind
  url_part_3 <- "?profile=xtab&format=html&x-topaxis=GHO&x-title=table&filter="
  empty_table_xml <- xml2::read_html(paste0(url_part_1, url_part_2, url_part_3))

  last_update_field <- stringr::str_extract(
    as.character(empty_table_xml),
    '\\"\\bLastUpdate\\b\\":\\"\\d\\d\\d\\d-\\d\\d-\\d\\d'
  )

  last_updated <- stringr::str_extract(
    as.character(empty_table_xml),
    '\\d\\d\\d\\d-\\d\\d-\\d\\d'
  )

  return(as.Date(last_updated))
}

#' Create dcast formula from two character vectors
#' 
#' @param cols_lhs LHS columns
#' @param cols_rhs RHS columns
#' @return formula
create_formula <- function(cols_lhs, cols_rhs) {
  lhs_str <- paste(cols_lhs, collapse=" + ")
  rhs_str <- paste(cols_rhs, collapse=" + ")
  
  return(stats::as.formula(paste(lhs_str, rhs_str, sep=" ~ ")))
}
