#' Load all data for the provided indicator.
#'
#' @export
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
#' @export
#' @return A data frame with all available indicators.
show_GHO_indicators <- function() {
  data <- download_ind("Indicator")

  return(data)
}


#' Transform table according to tidy philosophy
#' 
#' All data tables requested by the WHO API contain a SpatialDim, TimeDim,
#' Dim1, Dim2, Dim3 and DataSourceDim dimension. These dimensions have 
#' corresponding units, e.g. the type of the TimeDim column is typically
#' a year. 
#' 
#' We can transform the dimension and its corresponding dimension type to one 
#' column by setting the values of DimType to the column name and letting 
#' Dim be the values. Note that this sometimes results into multiple columns if 
#' if the DimType reports multiple units like years and months.
#' 
#' @export
#' @param data A raw WHO API dataset
#' @return A tidy-transformed WHO dataset
tidy_data <- function(data) {
  # Divide all columns up into dimension and non-dimension-related
  cols_idx_data_dim <- grep("Dim", colnames(data))
  cols_data_dim <- colnames(data)[cols_idx_data_dim]
  
  # Get all columns containing Dim but not Type
  cols_dim_type <- cols_data_dim[grep("Type", cols_data_dim)]
  cols_idx_dim_type <- cols_idx_data_dim[grep("Type", cols_data_dim)]
  cols_dim_val <- setdiff(cols_data_dim, cols_dim_type)
  
  # TODO we do not check whether type and val columns are matching
  data_new <- data
  for (i in 1:length(cols_dim_type)) {
    if (any(is.na(data[, cols_idx_dim_type[i]]))) {
      # if there exists NA values then we drop the columns. we need the column 
      # positions
      data.table::set(data_new, j=cols_dim_type[i], value=NULL)
      data.table::set(data_new, j=cols_dim_val[i], value=NULL)
    } else {
      # get all lhs columns
      cols_lhs <- setdiff(colnames(data_new), c(cols_dim_type[i], cols_dim_val[i]))
      
      # cast one column
      data_new <- data.table::dcast(
        data_new,
        create_formula(cols_lhs, cols_dim_type[i]),
        value.var=cols_dim_val[i]
      )
    }
  }
  
  return(data_new)
}
