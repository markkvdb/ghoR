m <- grep("(?<=https:\\/\\/ghoapi\\.azureedge\\.net\\/api\\/)[[:alpha:]]+(?=\\?)?", "https://ghoapi.azureedge.net/api/Indicator?", value=TRUE, perl=TRUE)
regmatches("https://ghoapi.azureedge.net/api/Indicator", m)
load_url_to_tibble <- function(url) {

  download.file(url="https://ghoapi.azureedge.net/api/Indicator",
                destfile="data/indicator.json",
                method="auto")
}

indicators <- ""

download.file(url="https://ghoapi.azureedge.net/api/Indicator",
              destfile="data/indicators.json",
              method="auto")


result <- rjson::fromJSON(file="data/indicators.json")[["value"]]
tmp <- do.call(dplyr::bind_rows, result)

m <- regexec("^(([^:]+)://)?([^:/]+)(/api/)([^?]*)(\\?.*)", x)
x <- "https://ghoapi.azureedge.net/api/Indicator?"
