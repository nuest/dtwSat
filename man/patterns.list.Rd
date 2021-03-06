% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{patterns.list}
\alias{patterns.list}
\title{Data: patterns time series}
\format{A named \code{list} of 3 \link[zoo]{zoo} objects, ''Soybean'', ''Cotton'', 
and ''Maize'', whose indices are \code{\link[base]{Dates}} in the format ''yyyy-mm-dd''.
Each node has 6 attributes: ''ndvi'', ''evi'', ''red'', ''nir'', ''blue'', 
and ''mir''.}
\usage{
patterns.list
}
\description{
This dataset has a list of patterns with the phenological cycle of: Soybean,
Cotton, and Maize. These time series are based on the MODIS product 
MOD13Q1 250 m 16 days [1]. The patterns were build from ground truth samples of each 
crop using Generalized Additive Models (GAM), see \link[dtwSat]{createPatterns}.
}
\author{
Victor Maus, \email{vwmaus1@gmail.com}
}
\references{
[1] Friedl MA, Sulla-Menashe D, Tan B, Schneider A, Ramankutty N, Sibley A, Huang X. (2010).
MODIS Collection 5 global land cover: Algorithm refinements and characterization of new
datasets. Remote Sensing of Environment, 114(1), 168 182.
}
\seealso{
\link[dtwSat]{example_ts},
\link[dtwSat]{example_ts.list}, and 
\link[dtwSat]{createPatterns}.

MOD13Q1 documentation: See 
\url{https://lpdaac.usgs.gov/dataset_discovery/modis/modis_products_table/mod13q1}.
}
\keyword{datasets}

