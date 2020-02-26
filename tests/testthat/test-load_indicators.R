test_that("reading GHO gives a data.table", {
  expect_is(read_GHO_data("WHOSIS_000001"), "data.table")
})

test_that("indicators table is a data.table", {
  expect_is(show_GHO_indicators(), "data.table")
})

test_that("indicators table has three columns", {
  ind_table <- show_GHO_indicators()
  ind_colnames <- colnames(ind_table)
  expect_identical(ind_colnames, c("IndicatorCode", "IndicatorName", "Language"))
})

test_that("invalid indicator gives error", {
  expect_error(read_GHO_data("THISISFAKE"), "Provided indicator does not exist in the WHO database.")
})

test_that("tidying data removes Dim value columns", {
  data <- tidy_data(read_GHO_data("WHOSIS_000001"))
  expect_equal(length(grep("Dim[0-9]?$", colnames(data))), 0)
})

test_that("tidying data removes Dim type columns", {
  data <- tidy_data(read_GHO_data("WHOSIS_000001"))
  expect_equal(length(grep("Dim[0-9]?Type$", colnames(data))), 0)
})

test_that("tidying data preserves original columns", {
  raw_data <- read_GHO_data("WHOSIS_000001")
  tidy_data <- tidy_data(raw_data)
  
  # get columns that should be preserved
  cols_keep <- colnames(raw_data)[grep("Dim", colnames(raw_data), invert=TRUE)]
  
  # check if tidy data contains the same columns still
  expect_identical(intersect(cols_keep, colnames(tidy_data)), cols_keep)
})