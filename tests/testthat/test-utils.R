test_that("url separation works", {
  result <- separate_url("https://ghoapi.azureedge.net/api/Indicator?")
  exp_result <- matrix(c("https",
                         "ghoapi.azureedge.net",
                         "/api/",
                         "Indicator",
                         "?" ), nrow=1)
  colnames(exp_result) <- c("protocol", "host", "api", "indicator", "filter")

  expect_equal(result, exp_result)
})

test_that("indicator to url works", {
  expect_equal(ind_to_url("RSUD_30"), "https://ghoapi.azureedge.net/api/RSUD_30")
})

test_that("indicator to json works", {
  expect_equal(ind_to_json("RSUD_30"), "~/.ghoR/RSUD_30.json")
})

#TODO test ind_in_cache()

test_that("downloaded file is data.table", {
  expect_is(download_ind("RSUD_30"), "data.table")
})

test_that("last update field is valid date", {
  expect_is(ind_to_last_update("RSUD_30"), "Date")
})
