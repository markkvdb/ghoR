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
