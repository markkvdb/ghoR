\name{create_hash_from_data}
\alias{create_hash_from_data}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Generate a SHA256 hash file from a downloaded WHO data file}
\description{
Creates a character string of length 64 containing the SHA256 hash of a given downloaded WHO data file. This is useful for comparing two data files and to detect whether a file has been changed/updated.
}
\usage{
create_hash_from_data(data)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{data}{      The downloaded WHO data file}
}

\value{a character string of length 64 containing the SHA256 hash}

\author{Shady el Gewily}

\examples{
data = download_ind("RSUD_30")
hash = create_hash_from_data(data)
}
